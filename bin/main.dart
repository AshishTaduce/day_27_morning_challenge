import 'dart:convert';
import 'dart:math';
import 'package:executor/executor.dart';
import 'package:http/http.dart';
import 'dart:async';

// Challenge 1
// Flutter module makes multiple, parallel, requests to a web service, and
// shares the result with the host app. We'll use the "balldontlie" API for this
// purpose, since it's open and supports cross-domain requests for web apps. in
// this case, the input value represents the number of calls to be made, eg a
// value of 3 means we will fetch data for players 1, 2, 3. The URL for player 2,
// for example, is:
// https://www.balldontlie.io/api/v1/players/1
// Once all calls have been made, the Flutter module should calculate average
// weight of all queried players and print it in console.
//  The calls must occur in parallel, always using up to *four* separate threads,
// in a typical "worker" pattern, to ensure there are always three pending requests
// until no further requests are needed. The requests should be logged when initiated
// and again when completed.

avgWeight(int noOfCalls) async {
  List <int> playerWeights = [];
  Executor executor = Executor(concurrency: 4);

  for(int i = 0; i < noOfCalls; i++){
    await executor.scheduleTask(() async{
      int currentPlayerWeight = await fetchPlayerWeight(i);
      if(currentPlayerWeight != null){
       playerWeights.add(currentPlayerWeight);
      }
    });
  }
  return playerWeights.reduce((a, b)=> a + b)/playerWeights.length;
}

Future fetchPlayerWeight(int i) async {
  Response response =
  await get('https://www.balldontlie.io/api/v1/players/${i + 1}');
  Map map = jsonDecode(response.body);
  return map['weight_pounds'];
}


// Challenge 2
// A point on the screen (pt1) wants to move a certain distance (dist) closer to
// another point on the screen (pt2) The function has three arguments,
// two of which are objects with x & y values, and the third being the distance,
// e.g. {x:50, y:60}, {x: 100, y: 100}, 10. The expected result is a similar
// object with the new co-ordinate.

Map<String, int> movePoint(Map pt1, Map pt2, int distanceToMove) {
  double totalDistance = // distance of (P, Q) = √ (x2 − x1)2 + (y2 − y1)2
  sqrt(
      (pt2['x'] * pt2['x'] - pt1['x'] * pt1['x']) +
      (pt2['y'] * pt2['y'] - pt1['y'] * pt1['y'])
  );

  if (totalDistance == 0 || totalDistance < distanceToMove) {
    return null;
  }
  distanceToMove.toDouble();
  double remainingDistance = totalDistance - distanceToMove;

  double xCord = ((distanceToMove * pt2['x']) + (remainingDistance * pt1['x'])) /
                                    (distanceToMove + remainingDistance);
  double yCord = ((distanceToMove * pt2['y']) + (remainingDistance * pt1['y'])) /
                                    (distanceToMove + remainingDistance);

  return {'x': xCord.toInt(), 'y': yCord.toInt()};
}

main() async{
  print(await avgWeight(5));
}
