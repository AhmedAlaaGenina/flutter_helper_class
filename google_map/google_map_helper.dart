// flutter_polyline_points: ^1.0.0

class GoogleMapHelper {
  Future<List<LatLng>> getPolyPoints(
      LatLng sourceLocation, LatLng destination) async {
    // how to use it
    // in google map widget
    // GoogleMap(
    // ...
    //   polylines: {
    //     Polyline(
    //       polylineId: const PolylineId("route"),
    //       points: polylineCoordinates,
    //       color: const Color(0xFF7B61FF),
    //       width: 6,
    //     ),
    //   },
    // ),

    List<LatLng> polylineCoordinates = [];
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
    return polylineCoordinates;
  }
}
