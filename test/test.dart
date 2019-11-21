import '../bin/main.dart';
import 'package:test/test.dart';

void main(){
  test("Test Case for movePOint", (){
    expect(movePoint({'x':50, 'y':60}, {'x': 100, 'y': 100},10), {'x': 54, 'y': 63});
    expect(movePoint({'x':0, 'y':0}, {'x': 0, 'y': 10},5), {'x': 0, 'y': 5});
    expect(movePoint({'x':0, 'y':0}, {'x': 0, 'y': 0},10), null);
    expect(movePoint({'x':50, 'y':60}, {'x': 100, 'y': 100}, 10), {'x': 54, 'y': 63});
  });
}