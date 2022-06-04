import collections
import json
import re
import sys
from itertools import chain

PATTERN = [
    "lele",
    "gurame",
    "tongkol",
    "mas",
    "mujaer",
    "bawal",
    "cumi",
    "nila",
    "kerapu",
    "salem",
    "bandeng",
    "kakap",
    "tenggiri",
    "kembung",
    "salam",
    "patin",
]
EXTRA_PATTERN = ["rata", "kecuali", "-", "sampai", "not"]


def read_json_file(file_path):
    with open(file_path, "r") as fd:
        return json.loads(fd.read())


def find_all_matching_values(value, patterns):
    matches = {}
    for match in chain.from_iterable(re.finditer(pattern, value, flags=re.IGNORECASE) for pattern in patterns):
        matches[match.start()] = match.group()
    return [v for _, v in collections.OrderedDict(sorted(matches.items())).items()]


def find_all_weight_values(value, extra_term):
    fact_x, fact_unit = "rata", "kg"
    if fact_x in extra_term and fact_unit in value:
        n_value = re.findall(r"(\d+(?:\.\d+)?)(kg| kg)", value)
        return [int(x[0]) for x in n_value]

    return list(map(int, re.findall(r"(?<!\.)\d+(?!\.)", value)))


def fine_grain_pattern_for_weight(weights, extra_term, len_comodity, len_weight):
    fact_x, fact_y = "rata", ["-", "sampai"]
    if fact_x in extra_term:
        x_weights = []
        if "not" in extra_term:
            x_weights += find_negation_value(weights)

        f_weights = [weights[0] for _ in range(1, len_comodity - len(x_weights))]
        if x_weights:
            f_weights += x_weights
        return f_weights

    if set(extra_term).issubset(fact_y):
        return [sum([int(x) for x in weights]) / len_weight]


def find_negation_value(value, patterns):
    n_value = re.findall(r"(not?.*kembung?.*[0-9])", value)
    if not n_value:
        return [0]
    return re.sub(r"[a-zA-Z]", "", n_value[0])


def normalize_value(value):
    min_number = "1kg"
    if re.findall(r"^se|(kilo?)", value, flags=re.I):
        return min_number

    if re.findall(r"^(ga|tidak|ten).*ntu$", value, flags=re.I):
        return min_number

    if not re.findall(r"[0-9]+", value):
        return min_number

    if re.findall(r"^[0-9]+([^\\][0-9])", value):
        return min_number

    n_value = re.sub(r"sampai", "-", value, flags=re.I)
    n_value = re.sub(r"kecuali", "not", n_value, flags=re.I)
    n_value = re.sub(r"hanya", "not", n_value, flags=re.I)
    n_value = re.sub(r"masing", "rata", n_value, flags=re.I)

    return n_value


def merge_values(comodities, weights, extra_term):
    len_comodities, len_weights = len(comodities), len(weights)
    if len_comodities == len_weights:
        return zip(comodities, weights)

    if len_comodities > len_weights:
        x_weights = [weights[0] for _ in range(1, len_comodities)]
        return zip(comodities, x_weights)

    if len_comodities < len_weights:
        x_weights = fine_grain_pattern_for_weight(weights, extra_term, len_comodities, len_weights)
        return zip(comodities, x_weights)
    return zip(comodities, weights)


def parse_values(values):
    parsed_values = []
    for cont in values:
        extra_term = find_all_matching_values(cont["berat"], EXTRA_PATTERN)
        comodity_idx = find_all_matching_values(cont["komoditas"], PATTERN)
        norm_weight = normalize_value(cont["berat"])
        weight_idx = find_all_weight_values(norm_weight, extra_term)
        cont["komoditas_idx"] = comodity_idx
        cont["norm_weight"] = norm_weight
        cont["berat_idx"] = weight_idx
        cont["extra_term"] = extra_term
        cont["merge_val"] = tuple(merge_values(comodity_idx, weight_idx, extra_term))
        parsed_values.append(cont)
    return parsed_values


def aggregated_values(parsed_values):
    agg_val = {}
    for val in parsed_values:
        merge_val = val.get("merge_val")
        if not merge_val:
            continue
        for key, val in merge_val:
            int_val = int(val)
            if not key in agg_val:
                agg_val[key] = int_val
                continue
            agg_val[key] += int_val
    return agg_val


def console_presentation(agg_val):
    no_idx = 1
    for comodity, val in agg_val.items():
        print(f"{no_idx}. {comodity} {val}kg")
        no_idx += 1


if __name__ == "__main__":
    arguments = sys.argv
    if len(arguments) > 1 > 2:
        filename = arguments[1] if arguments[1] else "soal-2.json"
        content = read_json_file(filename)
        parsed_values = parse_values(content)
        agg_val = aggregated_values(parsed_values)
        console_presentation(agg_val)

    print("need argument of json file dataset")
