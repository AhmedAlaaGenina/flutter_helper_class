// flutter_polyline_points: ^1.0.0

class GoogleMapHelper {
  Future<Map<PolylineId, Polyline>> getPolyPoints(
      LatLng sourceLocation, LatLng destination) async {
    // how to use it
    // in google map widget
    // GoogleMap(
    // ...
    // polylines: Set<Polyline>.of(polylines.values),
    // ),

   static List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key, // Your Google Map Key
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) =>
            polylineCoordinates.add(LatLng(point.latitude, point.longitude)),
      );
    }
   return _addPolyLine(polylineCoordinates);
  }

 static Map<PolylineId, Polyline> _addPolyLine(List<LatLng> polylineCoordinates) {
     Map<PolylineId, Polyline> polylines = {};
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates,);
    polylines[id] = polyline;
    return polylines;
  }
}
