def main():

    from json import load
    import os

    with open("../../.build/debug/codecov/VeryfiSDK.json") as file:
        test_result = load(file)
    code_coverage = get_code_coverage(test_result["data"][0]["files"])
    verify_unit_tests(code_coverage)
    code_coverage, code_coverage_color = number_to_badge(code_coverage)
    os.system("wget --output-document=code_coverage.svg https://img.shields.io/badge/code%20coverage-{}-{}".format
              (code_coverage, code_coverage_color))


def get_code_coverage(files):

    import re

    files_to_cover = ["NetworkManager.swift", "VeryfiSDK.swift"]
    file_getter = re.compile(r".+\/(.+?\.swift)$")
    lines, lines_covered = 0, 0
    for file in files:
        filename = file_getter.findall(file["filename"])[0]
        if filename not in files_to_cover:
            continue
        lines += int(file["summary"]["lines"]["count"])
        lines_covered += int(file["summary"]["lines"]["covered"])

    return lines_covered / lines


def number_to_badge(number):

    color = get_color(number)
    if number == 1:
        return "100%25", color
    number *= 100
    return str(round(number, 1)) + "%25", color


def get_color(number):

    if number < 0.6:
        return "red"
    if number < 0.8:
        return "yellow"
    if number < 0.92:
        return "green"
    return "brightgreen"


def verify_unit_tests(number):

    if number < 0.9:
        print("Code coverage < 90%")
        exit(-1)


if __name__ == "__main__":

    main()
