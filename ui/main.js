
let climaData = {};
let currentZoomLevel = 13;

const lat = 49.450167984856776;
const long = 11.07940281406232;
const map = L.map('map').setView([lat, long], currentZoomLevel);
const tiles = L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    minZoom: 10,
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
    // check if zoom level changed
    // https://stackoverflow.com/questions/18770517/leaflet-js-get-current-zoom-level

}).addTo(map);

map.on('zoomend',function(e){
	let updatedZoomLevel = map.getZoom();
    let diff = currentZoomLevel - updatedZoomLevel;
    if(diff != 0){
  	   console.log(`zoom changed from : ${currentZoomLevel} to ${updatedZoomLevel}`);
    }
    currentZoomLevel = updatedZoomLevel;
    updateMap();
});





fetch('./data.json')
    .then(response => response.json())
    .then(data => {
        climaData = data;
        updateMap();
    })
    .catch(error => console.log(error));

function updateMap() {
    // reset Map
    //L.map('map').eachLayer(function (layer) {
    map.eachLayer(function (layer) {
        if (layer instanceof L.Polygon) {
            map.removeLayer(layer);
        }
    });

    /*
        const h3Index = h3.latLngToCell(long, lat, 9);
        console.log(h3Index);
        const hexBoundary = h3.cellToBoundary(h3Index, true);
        console.log(hexBoundary);
        const hexPolygon = hexBoundary.map((boundary) => [boundary[0], boundary[1]]);
        const hex = L.polygon(hexPolygon, {
            color: '#838278',
            weight: 1,
            opacity: 0.65,
            // fillColor: '#ece385', // yellow
            // fillColor: '#d98e04', // orange
            fillColor: '#ff4149', // red
            // fillColor: '#38994d', // green
            fillOpacity: 0.4,
        }).addTo(map);
        */

        //var hexagons = data.res5;
        var hexagons = {}
        
        if(currentZoomLevel <12) {
            hexagons = climaData.res6;
        } else if(currentZoomLevel < 13){
            hexagons = climaData.res7;
        } else if(currentZoomLevel < 15){
            hexagons = climaData.res8;
        } else if(currentZoomLevel < 17){
            hexagons = climaData.res9;
        } else if(currentZoomLevel < 19){
            hexagons = climaData.res10;
        } else if(currentZoomLevel < 20){
            hexagons = climaData.res11;
        }

        // res15



        for (i in hexagons) {
            //console.log(hexagons[i]);
            var hexagon = hexagons[i];

            const hexBoundary = h3.cellToBoundary(hexagon.index, true);
            //console.log(hexBoundary);
            const hexPolygon = hexBoundary.map((boundary) => [boundary[1], boundary[0]]);
            //console.log(hexPolygon);

            
            // 10 grad minimum, 40 grad maximum
            let minTemp = 13;
            let maxTemp = 21;
            let colorFactor = 0;
            if(hexagon.temperature > maxTemp){
                colorFactor = 1;
            } else if(hexagon.temperature > minTemp){
                colorFactor = (hexagon.temperature - minTemp) / (maxTemp - minTemp);
            }
        
            let minValue = 68;
            let range = 137;
            let gValue = Math.round((1-colorFactor) * range + minValue);
            // console.log(`temp: ${hexagon.temperature} -> gValue: ${gValue}, colorFactor: ${colorFactor}`);

            // 68 + 137 = 205 => minTemp
            // 68 + 0 = 68 => maxTemp


            const hex = L.polygon(hexPolygon, {
                color: '#838278',
                weight: 1,
                opacity: 0.65,
                // fillColor: '#ece385', // yellow
                // fillColor: '#d98e04', // orange
                // fillColor: '#ff4149', // red
                //fillColor: '#38994d', // green
                fillColor: `rgb(217,${gValue},43)`, // gelb
                //fillColor: 'rgb(217,68,43)', //rot
                fillOpacity: 0.4,
            }).addTo(map);
            hex.bindPopup(`Index: ${hexagon.index}<br>${hexagon.info}`);

            //map.setView(hexPolygon[0], 13);
                //.bindPopup(`Index: ${hexagon.index}<br>${hexagon.info}`);
        }
}

/**
  final resolution = switch (zoom) {
    < 4 => 1,
    < 5 => 2,
    < 7 => 3,
    < 8 => 4,
    < 10 => 5,
    _ => 10,
  };
 */



/*const marker = L.marker([51.5, -0.09]).addTo(map)
    .bindPopup('<b>Hello world!</b><br />I am a popup.').openPopup();
*/
/*const circle = L.circle([51.508, -0.11], {
    color: 'red',
    fillColor: '#f03',
    fillOpacity: 0.5,
    radius: 500
}).addTo(map).bindPopup('I am a circle.');
*/


/*const popup = L.popup()
    .setLatLng([51.513, -0.09])
    .setContent('I am a standalone popup.')
    .openOn(map);
*/

function onMapClick(e) {
    /*popup
        .setLatLng(e.latlng)
        .setContent(`You clicked the map at ${e.latlng.toString()}`)
        .openOn(map);
        */
}

map.on('click', onMapClick);
