# README

Example using GeoJSON locations

[DEMO](http://geojsondemo.herokuapp.com/areas)

### Check the last area:

GET: localhost:3000/areas

### Check if point is inside example:

POST: localhost:3000/inside

PARAMS:

```json
{
  "point": {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [-43.1982421875, -7.406047717076258]
      },
      "properties": {
        "name": "Dinagat Islands"
      }
    }
}
```

### Check for specific area:

GET: localhost:3000/feature_collections/:id

### Set area example:

POST: localhost:3000/feature_collections/

PARAMS:

```json
{
  "feature_collection": {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "properties": {},
          "geometry": {
            "type": "Polygon",
            "coordinates": [
              [
                [
                  -40.869140625,
                  -3.337953961416472
                ],
                [
                  -40.78125,
                  -9.535748998133615
                ],
                [
                  -31.904296874999996,
                  -9.015302333420586
                ],
                [
                  -32.16796875,
                  -2.460181181020993
                ],
                [
                  -40.869140625,
                  -3.337953961416472
                ]
              ]
            ]
          }
        }
      ]
    }
 }
```

### Search by name (and get an ID):

POST: localhost:3000/coordinates

PARAMS:

```json
{
	"location": {
		"query": "fortaleza"
	}
}
```

### See API search result with ID:

GET: localhost:3000/coordinates/:id

