import json
import requests
from geopy.geocoders import Nominatim
import osm2geojson

OVERPASS_URL = "http://overpass-api.de/api/interpreter"
DEFAULT_AREA = "Nuremberg"

green_items = [
    "amenity=grave_yard",
    "landuse=allotments",
    "landuse=farmland",
    "landuse=orchard",
    "landuse=village_green",
    "landuse=vineyard",
    "landuse=greenfield",
    "landuse=forest",  # Incomplete polygon with nwr
    "landuse=grass",  # Incomplete polygon with nwr
    "landuse=meadow",  # Incomplete polygon with nwr
    "landuse=cemetery",  # Incomplete polygon with nwr
    "landuse=recreation_ground",  # Incomplete polygon with nwr
    "leisure=dog_park",
    "leisure=golf_course",
    "leisure=common",  # Is this green?
    "leisure=garden",  # Incomplete polygon with nwr
    "leisure=nature_reserve",  # Incomplete polygon with nwr
    "leisure=park",  # Incomplete polygon with nwr
    "leisure=pitch",  # Is this green?  # Incomplete polygon with nwr
    "leisure=playground",
    "natural=moor",
    "natural=heath",  # Is this green?
    "natural=fell",  # Is this green?
    "natural=grassland",  # Incomplete polygon with nwr
    "natural=wood",  # Incomplete polygon with nwr
    "natural=scrub",  # Is this green?  # Incomplete polygon with nwr
    "tourism=camp_site",
]

water_items = ["natural=water", "waterway=river"]


def get_area_id(city_name: str):
    # Geocoding request via Nominatim
    geolocator = Nominatim(user_agent="city_compare")
    geo_results = geolocator.geocode(city_name, exactly_one=False, limit=3)

    # Searching for relation in result set
    for r in geo_results:
        # print(r.address, r.raw.get("osm_type"))
        if r.raw.get("osm_type") == "relation":
            city = r
            break

    # Calculating area id
    area_id = int(city.raw.get("osm_id")) + 3600000000
    return area_id


def read_json(filepath):
    with open(filepath, "r") as f:
        return json.load(f)


def exec_query(area_id: int, query: str):
    request = f"[out:json];area({area_id})->.searchArea;({query});out geom;"
    response = requests.get(OVERPASS_URL, params={"data": request})
    response.raise_for_status()
    data = response.json()
    return osm2geojson.json2geojson(data)


def gen_query(query_list: list[str], query_key: str = "nwr"):
    return "".join(
        [f"{query_key}[{query_item}](area.searchArea);" for query_item in query_list]
    )


def osm_query(items: list[str], area=DEFAULT_AREA):
    area_id = get_area_id(area)
    return exec_query(area_id, gen_query(items))


def write_output_geojson(geo_json, filename):
    print(json.dumps(geo_json, indent=2))
    with open(filename, "w") as of:
        json.dump(geo_json, of)


if __name__ == "__main__":
    write_output_geojson(osm_query(green_items), "osm_fetch/data_green.geojson")
    write_output_geojson(osm_query(water_items), "osm_fetch/data_water.geojson")
