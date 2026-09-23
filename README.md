# Customer Shopping Trends Analysis

A SQL analysis of shopping behavior for 3,900 customers, exploring seasonal demand, location-based trends, customer demographics, and the relationship between purchase frequency and spend — to support business decisions around inventory and stocking strategy.

This project covers a single, focused layer of the analysis pipeline: **SQL Analysis (verified against the raw dataset)**. It does not (yet) include a data-cleaning notebook or a BI dashboard — see [Possible Next Steps](#possible-next-steps) if you want to extend it that way.

---

## Table of Contents
- [Dataset Overview](#dataset-overview)
- [Analysis Workflow](#analysis-workflow)
- [Business Questions Answered](#business-questions-answered)
- [Key Insights](#key-insights)
- [Tech Stack & Skills Demonstrated](#tech-stack--skills-demonstrated)
- [Project Structure](#project-structure)
- [How to Run](#how-to-run)
- [Possible Next Steps](#possible-next-steps)

---

## Dataset Overview

The dataset contains **3,900 rows** and **18 columns** describing customer transactions: age, gender, item purchased, category, purchase amount, location, color, size, season, review rating, subscription status, shipping type, discount/promo usage, previous purchases, payment method, and purchase frequency.

| Attribute | Value |
|---|---|
| Rows | 3,900 |
| Columns | 18 |
| Time period | Snapshot data (no transaction timestamp) |
| Source | `shopping_trends.csv` |

---

## Business Questions Answered

The SQL analysis (see [`shopping_trends_analysis.sql`](shopping_trends_analysis.sql)) answers 8 questions a retail business would realistically ask:

| # | Question |
|---|---|
| 1 | How many unique customers visited the store during the time period? |
| 2 | Should the store stock more male or female clothing? |
| 3 | What seasons are present in the data? |
| 4 | What are the top 3 most purchased items per season? |
| 5 | What's the most popular item color per season? |
| 6 | Should stocking strategy vary by store location? |
| 7 | Which locations have the best customer experience (review ratings)? |
| 8 | Does having 10+ previous purchases correlate with higher spend per order? |

---

## Key Insights

- **3,900 unique customers** in the dataset.
- **68% of customers are male** vs. 32% female (by customer count) — the assortment should skew toward men's clothing, though this is a customer-count split, not a revenue-weighted one (revenue-by-gender is not yet broken out — see Next Steps).
- **Seasonal demand shifts clearly**: Jacket/Hat/Handbag lead in Fall, Sunglasses/Pants/Shirt lead in Winter, Sweater/Shorts/Skirt lead in Spring, Pants/Jewelry/Dress lead in Summer.
- **Color preference also shifts by season**: Silver in Summer, Olive in Spring, Yellow in Fall, Green in Winter — useful for merchandising displays.
- **Location matters**: top-selling items in Fall/Montana (Handbag, T-shirt, Sweater...) differ from the overall Fall top-3 (Jacket, Hat, Handbag), supporting a location-tailored stocking strategy rather than a one-size-fits-all national plan.
- **Texas (3.91) and Wisconsin (3.89)** have the highest average review ratings — worth studying what those regions do differently.
- **"10+ previous purchases" is a loyalty signal, not a bigger-basket signal**: that group generates far higher *total* revenue ($189,939 vs. $43,142) simply because there are more of them (3,192 vs. 708 orders), but their *average order value* (~$59.50) is nearly identical to newer customers (~$60.94). The actionable insight is retention value, not upselling frequent buyers.

