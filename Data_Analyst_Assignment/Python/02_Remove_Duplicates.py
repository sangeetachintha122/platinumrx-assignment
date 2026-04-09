"""
Remove duplicate characters from a string while preserving original order.

Usage:
    python 02_Remove_Duplicates.py "balloon"
Output:
    balon
"""

import argparse


def unique_string(value: str) -> str:
    """Return a string with only the first occurrence of each character kept."""
    if value is None:
        raise ValueError("Input string is required.")

    seen = set()
    output_chars = []
    for ch in value:
        if ch not in seen:
            seen.add(ch)
            output_chars.append(ch)
    return "".join(output_chars)


def main() -> None:
    parser = argparse.ArgumentParser(description="Remove duplicate characters from a string.")
    parser.add_argument("text", help="Input string, e.g., 'Programming'")
    args = parser.parse_args()
    print(unique_string(args.text))


if __name__ == "__main__":
    main()
