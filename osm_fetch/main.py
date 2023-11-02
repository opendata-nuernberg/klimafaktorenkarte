import overpass
import json
from geopy.geocoders import Nominatim

api = overpass.API()
DEFAULT_AREA = "Nuremberg"

green_items = [
    "tourism=camp_site",
    "leisure=dog_park",
    "landuse=greenfield",
    "leisure=golf_course",
    "amenity=grave_yard",
    "landuse=orchard",
    "landuse=village_green",
    "landuse=vineyard",
    "natural=moor",
    "natural=heath",  # Is this green?
    "natural=fell",  # Is this green?
    "leisure=common",  # Is this green?
    # Incomplete with nwr:
    "landuse=forest",  # Incomplete polygon
    "leisure=garden",  # Incomplete polygon
    "landuse=grass",  # Incomplete polygon
    "natural=grassland",  # Incomplete polygon
    "landuse=meadow",  # Incomplete polygon
    "leisure=nature_reserve",  # Incomplete polygon
    "leisure=park",  # Incomplete polygon
    "landuse=recreation_ground",  # Incomplete polygon
    "natural=wood",  # Incomplete polygon
    "landuse=cemetery",  # incomplete polygons
    "leisure=pitch",  # Is this green?  # Incomplete polygon
    "natural=scrub",  # Is this green?  # Incomplete polygon
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
    return api.get(
        f"""area({area_id})->.searchArea;
({query});
out geom;
"""
    )


def gen_query(query_list: list[str], query_key: str = "way"):
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
    # osm_json = read_json("osm_fetch/test_data/osm_test_data_1.json")
    write_output_geojson(osm_query(green_items), "osm_fetch/data_green.geojson")
    write_output_geojson(osm_query(water_items), "osm_fetch/data_water.geojson")
