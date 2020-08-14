import 'package:flutter/material.dart';
import 'package:swipe_maze/maze.dart';
import 'package:swipe_maze/swipe_maze_screen.dart';

class SwipeMazeScreen3 extends StatelessWidget {
  final Maze maze;

  const SwipeMazeScreen3(this.maze);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MazeContainer(maze),
    );
  }
}

class MazeContainer extends StatefulWidget {
  final Maze maze;

  const MazeContainer(this.maze);

  @override
  _MazeContainerState createState() => _MazeContainerState(
        x: maze.start.x,
        y: maze.start.y,
      );
}

class _MazeContainerState extends State<MazeContainer> {
  int x = 0;
  int y = 0;
  int lastVerticalPage = 1000;
  int lastHorizontalPage = 1000;
  final controllerVertical = new PageController(initialPage: 1000);
  final controllerHorizontal = new PageController(initialPage: 1000);

  _MazeContainerState({this.x, this.y});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controllerVertical,
      scrollDirection: Axis.vertical,
      onPageChanged: _onVerticalScroll,
      //physics: CustomScrollPhysics(),
      itemBuilder: (context, index) {
        return PageView.builder(
          controller: controllerHorizontal,
          scrollDirection: Axis.horizontal,
          onPageChanged: _onHorizontalScroll,
          itemBuilder: (context, index) => Tile(
            closedTop: widget.maze.isClosed(x + 0, y - 1),
            closedRight: widget.maze.isClosed(x + 1, y + 0),
            closedBottom: widget.maze.isClosed(x + 0, y + 1),
            closedLeft: widget.maze.isClosed(x - 1, y + 0),
            isStart: widget.maze.isStart(x, y),
            isEnd: widget.maze.isEnd(x, y),
          ),
        );
      },
    );
  }

  void _onVerticalScroll(int page) {
    setState(() {
      y += page - lastVerticalPage;
      lastVerticalPage = page;
      lastHorizontalPage = 1000;
    });
  }

  void _onHorizontalScroll(int page) {
    setState(() {
      x += page - lastHorizontalPage;
      lastHorizontalPage = page;
    });
  }
}

/*class CustomScrollPhysics extends ScrollPhysics {
  CustomScrollPhysics({ScrollPhysics parent}) : super(parent: parent);

  bool isGoingLeft = false;

  @override
  CustomScrollPhysics applyTo(ScrollPhysics ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    isGoingLeft = offset.sign < 0;
    return offset;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    //print("applyBoundaryConditions");
    assert(() {
      if (value == position.pixels) {
        throw FlutterError(
            '$runtimeType.applyBoundaryConditions() was called redundantly.\n'
            'The proposed new position, $value, is exactly equal to the current position of the '
            'given ${position.runtimeType}, ${position.pixels}.\n'
            'The applyBoundaryConditions method should only be called when the value is '
            'going to actually change the pixels, otherwise it is redundant.\n'
            'The physics object in question was:\n'
            '  $this\n'
            'The position object in question was:\n'
            '  $position\n');
      }
      return true;
    }());
    if (value < position.pixels && position.pixels <= position.minScrollExtent)
      return value - position.pixels;
    if (position.maxScrollExtent <= position.pixels && position.pixels < value)
      // overscroll
      return value - position.pixels;
    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels) // hit top edge

      return value - position.minScrollExtent;

    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value) // hit bottom edge
      return value - position.maxScrollExtent;

    if (!isGoingLeft) {
      return value - position.pixels;
    }
    return 0.0;
  }
}*/

class TestTile extends StatelessWidget {
  final int x;
  final int y;

  TestTile({this.x, this.y}) : super(key: UniqueKey());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('$x,$y'),
    );
  }
}
