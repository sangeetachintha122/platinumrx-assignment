"""
Convert a minute count into a human-readable hours/minutes string.

Usage:
    python 01_Time_Converter.py 130
    python 01_Time_Converter.py --minutes 110
"""

import argparse
from typing import Union


def minutes_to_text(total_minutes: Union[int, float]) -> str:
    """Convert minutes to a string like '2 hrs 10 minutes'. Raises ValueError for negatives."""
    if total_minutes is None:
        raise ValueError("Minutes value is required.")
    if total_minutes < 0:
        raise ValueError("Minutes cannot be negative.")

    minutes_int = int(round(total_minutes))
    hours, minutes = divmod(minutes_int, 60)

    parts = []
    if hours:
        suffix = "hr" if hours == 1 else "hrs"
        parts.append(f"{hours} {suffix}")
    # Always show minutes to match examples
    minute_label = "minute" if minutes == 1 else "minutes"
    parts.append(f"{minutes} {minute_label}")

    return " ".join(parts)


def main() -> None:
    parser = argparse.ArgumentParser(description="Convert minutes to human-readable time.")
    parser.add_argument(
        "minutes",
        type=float,
        nargs="?",
        help="Total minutes (can be fractional). Example: 130",
    )
    parser.add_argument(
        "--minutes",
        type=float,
        dest="minutes_kw",
        help="Alternate way to pass minutes.",
    )
    args = parser.parse_args()

    minutes_value = args.minutes if args.minutes is not None else args.minutes_kw
    if minutes_value is None:
        parser.error("Please provide minutes (positional or --minutes).")

    print(minutes_to_text(minutes_value))


if __name__ == "__main__":
    main()
