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
  this.origin = {
    x:Math.min($elem.attr("start_x"),$elem.attr("end_x")),
    y:Math.min($elem.attr("start_y"),$elem.attr("end_y"))
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
    var x = Math.floor(prc * ($elem.attr("end_x") - $elem.attr("start_x")));
    var y = Math.floor(prc * ($elem.attr("end_y") - $elem.attr("start_y")));
    
    console.log(prc);
    if(this.pos.x != x || this.pos.y != y){
      this.pos.x = x;
      this.pos.y = y;
      this.mover.css({left:(this.pos.x - this.origin.x)+"px",top:(this.pos.y - this.origin.y)+"px"});
    }
  }
}