var movements = {};

function registerMovements(content){
  var $content = $(content);
  $('.movement',$content).each(function(){
    registerMovement(this);
  })
}

function registerMovement(elem){
  var $elem = $(elem);
  if(typeof movements[$elem.attr("data_id")] == "undefined"){
    var movement = new Movement($elem);
    movements[$elem.attr("data_id")] = movement;
    movement.update();
  }else{
    $elem.remove();
  }
}

function Movement($elem){
  this.elem = $elem;
  this.mover = $(".soldiers",$elem);
  this.data_id = $elem.attr("data_id");
  this.pos = {
    x:NaN,
    y:NaN
  };
  this.start = {x:parseInt($elem.attr("start_x")),y:parseInt($elem.attr("start_y"))};
  this.end = {x:parseInt($elem.attr("end_x")),y:parseInt($elem.attr("end_y"))};
  this.origin = {
    x:Math.min(this.start.x,this.end.x),
    y:Math.min(this.start.y,this.end.y)
  };
  
  this.elem.css({left:this.origin.x+"px",top:this.origin.y+"px"}).appendTo(".worldView .content");
  this.update = function(){
    var start_time = this.elem.attr("start_time");
    var end_time = this.elem.attr("end_time");
    var curTime = new Date().getTime() / 1000;
    this.setPos( Math.min(1,( curTime - start_time) / (end_time - start_time)) );
  }
  this.setPos = function(prc){
    this.prc = prc;
    console.log(prc);
    var newPos = Movement.ptAtLinePrc( this.start, this.end, prc);
    console.log(this.start);
    console.log(this.end);
    console.log(newPos);
    if(this.pos.x != newPos.x || this.pos.y != newPos.y){
      this.pos.x = newPos.x;
      this.pos.y = newPos.y;
      var localPos = this.localPos();
      this.mover.css({left:localPos.x+"px",top:localPos.y+"px"});
    }
  }
  
  this.localPos = function(pos){
    if(typeof pos != "object") pos = this.pos;
    return {x:pos.x - this.origin.x,y:pos.y - this.origin.y}
  }
  
  this.draw = function(){
    if(typeof this.arrow == "undefined"){
      var start = this.localPos(this.start);
      var end = this.localPos(this.end);
      var width = Math.max(start.x,end.x)+40;
      var height = Math.max(start.y,end.y)+30;
      end = Movement.ptAtLinePrc( start, end, 1 - 15/Movement.lineDistance(start,end));
      this.arrow = $(
        ['<svg width="'+width+'" height="'+height+'">',
        '  <defs>',
        '    <marker id="arrow" markerWidth="9" markerHeight="9" refx="2" refy="4" orient="auto">',
        '      <path d="M2,2 L2,6 L5,4 L2,2" style="fill:red;" />',
        '    </marker>',
        '  </defs>',
        '  <path d="M'+(start.x+20)+','+(start.y+15)+' L'+(end.x+20)+','+(end.y+15)+'" style="stroke:red; stroke-width: 5px; fill: none; marker-end: url(#arrow);" />',
        '</svg>'
        ].join('\n'));
      this.elem.append(this.arrow);
    }
  }
  
  
  this.draw();
}


Movement.lineDistance = function( point1, point2 ){
  var xs = point2.x - point1.x;
  xs *= xs;
  var ys = point2.y - point1.y;
  ys *= ys;
  return Math.sqrt( xs + ys );
}
Movement.ptAtLinePrc = function( point1, point2 , prc){
  return {
    x : Math.floor(prc * (point2.x - point1.x)) + point1.x,
    y : Math.floor(prc * (point2.y - point1.y)) + point1.y
  };
}