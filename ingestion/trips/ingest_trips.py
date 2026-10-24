import pathlib, requests, duckdb, yaml

ROOT = pathlib.Path("data")
cfg = yaml.safe_load(open("ingestion/trips/months.yml"))

for month in cfg["months"]:
    csv = ROOT / "landing" / f"{month['month']}.csv"
    out = ROOT / "raw" / "trips" / f"month={month['month']}" / "trips.parquet"
    csv.parent.mkdir(parents=True, exist_ok=True)
    out.parent.mkdir(parents=True, exist_ok=True)

    if not csv.exists():
        response = requests.get(month["url"], timeout=120)
        response.raise_for_status()
        csv.write_bytes(response.content)

    duckdb.sql(f"""
        COPY(
            SELECT *
                 , '{month['month']}'   AS _month
                 , '{month['url']}'     AS _source_url
                 , now()                AS _loaded_at
              FROM read_csv('{csv}', all_varchar=true)
        ) TO '{out}' (FORMAT parquet)
    """)

    print("done", month["month"])