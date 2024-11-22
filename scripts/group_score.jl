# # This is the script for group presentation scores.
# General
# - A-D (total four group)
# - 12/16 explain in class. (all should be prepared).
#
# (1) `A` scores other groups (`B`, `C`, `D`):
# - 5% (absolute score 1 to 5)
# - 12/23 `A` and `B` present
# - 12/30 `C` and `D` present
#
# (2) Member `one` scores others:
# - 10% (absolute score 1 to 10)
#
#
# Shortnote:
# - (1): Three QRCodes for each student (for the other three groups), fill into Google form (a).
# - (2): Three QRCodes for each student (for the other 3 team members), fill into Google form (b).
# - (a): 評分者、被評組別、分數
# - (b): 評分者、被評組員、分數
#
#
# Verification:
# - (a): one 評分者 should have exactly three answers where 被評組別 is the other three.
# - (b): one 評分者 should have exactly three answers where 被評組員 is the other three.

using JSON, OkReadGSheet, DataFrames, CSV, Chain
# using SMTPClient, HypertextLiteral
using Dates
using OkReadGSheet
