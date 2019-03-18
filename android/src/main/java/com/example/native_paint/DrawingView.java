package com.example.native_paint;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.PathMeasure;
import android.graphics.Point;
import android.graphics.PointF;
import android.graphics.Region;
import android.graphics.Region.Op;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import java.util.ArrayList;
import java.util.List;

class PathHelperObject {
  final Path path;
  final Paint paint;

  PathHelperObject(Path path, Paint paint) {
    this.path = path;
    this.paint = paint;
  }
}

class DrawingView extends View {

  private List<PathHelperObject> pathList;
  private Path drawPath;
  private Paint drawPaint, canvasPaint;
  private Bitmap canvasBitmap;
  private List<PointF> firstPaintPointsList;

  public DrawingView(Context context) {
    super(context);
    setupDrawing();
  }

  private void setupDrawing(){
    pathList = new ArrayList<>();
    drawPath = new Path();
    drawPaint = new Paint();
    drawPaint.setColor(0xff000000);
    drawPaint.setAntiAlias(true);
    drawPaint.setStyle(Paint.Style.STROKE);
    drawPaint.setStrokeJoin(Paint.Join.ROUND);
    drawPaint.setStrokeCap(Paint.Cap.ROUND);
    canvasPaint = new Paint(Paint.DITHER_FLAG);
    drawPaint.setStrokeWidth(20);
  }

  @Override
  protected void onSizeChanged(int w, int h, int oldw, int oldh) {
    super.onSizeChanged(w, h, oldw, oldh);
    canvasBitmap = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888);
    //drawCanvas = new Canvas(canvasBitmap);
  }

  @Override
  protected void onDraw(Canvas canvas) {
    super.onDraw(canvas);
    canvas.drawBitmap(canvasBitmap, 0, 0, canvasPaint);

    for (PathHelperObject path : pathList) {
      canvas.drawPath(path.path, path.paint);
    }
    canvas.drawPath(drawPath, drawPaint);
  }

  @Override
  public boolean onTouchEvent(MotionEvent event) {
    float touchX = event.getX();
    float touchY = event.getY();
    switch (event.getAction()) {
      case MotionEvent.ACTION_DOWN:
        drawPath.moveTo(touchX, touchY);
        break;
      case MotionEvent.ACTION_MOVE:
        drawPath.lineTo(touchX, touchY);
        break;
      case MotionEvent.ACTION_UP:
        if (pathList.size() > 0) checkIntersect();
        else pathList.add(new PathHelperObject(new Path(drawPath), drawPaint));
        drawPath.reset();
        break;
      default:
        return false;
    }
    invalidate();
    return true;
  }

  private void checkIntersect() {
    if (firstPaintPointsList == null) {
      firstPaintPointsList = new ArrayList<>();
      Path firstPath = pathList.get(0).path;
      PathMeasure pathMeasure = new PathMeasure(firstPath, false);
      Log.d("DrawingView", "First path measure length: " + pathMeasure.getLength());
      float[] coordinates = new float[2];
      for (int i = 0; i < pathMeasure.getLength(); i++) {
        pathMeasure.getPosTan(i, coordinates, null);
        firstPaintPointsList.add(new PointF(coordinates[0], coordinates[1]));
      }
    }

    Region clip = new Region();
    clip.set(0, 0, canvasBitmap.getWidth(), canvasBitmap.getHeight());
    Region currentPathRegion = new Region();
    currentPathRegion.setPath(drawPath, clip);
    Paint currentPathPaint = new Paint(drawPaint);
    for (PointF point : firstPaintPointsList) {
      if (currentPathRegion.contains((int) point.x, (int) point.y)) {
        currentPathPaint.setColor(0xffff0000);
      }
    }
    pathList.add(new PathHelperObject(new Path(drawPath), currentPathPaint));
  }
}
