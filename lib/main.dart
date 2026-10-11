<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no">
<title>DRIVER BAGHDAD</title>

<style>
*{box-sizing:border-box;touch-action:manipulation}
body{margin:0;background:#18232b;color:white;font-family:Arial,sans-serif;overflow:hidden}
canvas{position:absolute;width:100%;height:100%;inset:0}
#hud{position:absolute;inset:0;pointer-events:none}
.top{
 position:absolute;top:12px;left:10px;right:10px;
 display:flex;justify-content:space-between;gap:8px;
}
.panel{background:#101820df;padding:10px;border-radius:12px}
h2{margin:0;color:#ffb21a;font-size:19px;direction:ltr}
small{color:#ddd}
.stats{text-align:center;font-size:12px}
.stats b{display:block;color:#ffb21a;font-size:18px}
.identity{position:absolute;top:78px;right:10px;font-size:12px;line-height:1.8}
#menu{
 position:absolute;top:40%;left:50%;transform:translate(-50%,-50%);
 background:#101820ed;padding:22px;border-radius:18px;
 width:88%;max-width:380px;text-align:center;
 pointer-events:auto
}
#menu h1{color:#ffb21a;font-size:26px;direction:ltr}
button{border:0;border-radius:13px;padding:14px;font-weight:bold;font-size:16px}
.start{background:#ffb21a;color:#111;width:100%}
#controls{
 position:absolute;bottom:20px;left:12px;right:12px;
 display:flex;justify-content:space-between;align-items:end;
 pointer-events:none
}
.group{display:flex;gap:8px;align-items:end;pointer-events:auto}
.ctrl{
 width:62px;height:62px;border-radius:50%;
 background:#101820df;color:white;border:2px solid #ffffff70;
 font-size:23px;padding:0;user-select:none
}
.pedal{
 width:64px;height:75px;background:#23353f;color:white;
 border:2px solid #ffffff50;border-radius:15px;padding:5px
}
.pedal small{display:block;margin-top:7px}
button:active{background:#ffb21a;color:#111}
#notice{
 position:absolute;bottom:105px;left:50%;transform:translateX(-50%);
 background:#101820dd;padding:8px 12px;border-radius:20px;
 font-size:12px;white-space:nowrap
}
</style>
</head>

<body>
<canvas id="game"></canvas>

<div id="hud">
 <div class="top">
  <div class="panel">
   <h2>DRIVER BAGHDAD</h2>
   <small>درايفر بغداد 🇮🇶</small>
  </div>
  <div class="panel stats">
   السرعة
   <b><span id="speed">0</span> كم/س</b>
   المسافة <span id="distance">0</span> م
  </div>
 </div>

 <div class="identity panel">
  <b style="color:#ffb21a">السائق:</b> علاوي ال حمادي<br>
  <b style="color:#ffb21a">رقم العرض:</b> 07880254887
 </div>

 <div id="menu">
  <h1>DRIVER BAGHDAD</h1>
  <p>عالم السيارات وشوارع بغداد 🇮🇶</p>
  <p>سوق سيارتك واستكشف الطريق!</p>
  <button class="start" id="start">ابدأ القيادة 🚘</button>
 </div>

 <div id="notice">بغداد · طريق دجلة</div>

 <div id="controls">
  <div class="group">
   <button class="ctrl" data-key="left">◀</button>
   <button class="ctrl" data-key="right">▶</button>
   <button class="ctrl" id="horn">📣</button>
  </div>
  <div class="group">
   <button class="pedal" data-key="brake">▰<small>فرامل</small></button>
   <button class="pedal" data-key="gas">▲<small>GAS</small></button>
  </div>
 </div>
</div>

<script>
const canvas=document.getElementById("game");
const ctx=canvas.getContext("2d");

let W,H;
let speed=0;
let distance=0;
let roadMove=0;
let lane=0;
let steering=0;
let playing=false;
let last=0;

const keys={
 left:false,
 right:false,
 gas:false,
 brake:false
};

let audio=null;
let engine=null;
let engineGain=null;
let master=null;
let audioReady=false;

function resize(){
 W=innerWidth;
 H=innerHeight;
 canvas.width=W*devicePixelRatio;
 canvas.height=H*devicePixelRatio;
 canvas.style.width=W+"px";
 canvas.style.height=H+"px";
 ctx.setTransform(devicePixelRatio,0,0,devicePixelRatio,0,0);
}
addEventListener("resize",resize);
resize();

function initSound(){
 try{
  if(audioReady)return;
  audio=new(window.AudioContext||window.webkitAudioContext)();
  master=audio.createGain();
  master.gain.value=.15;
  master.connect(audio.destination);

  engine=audio.createOscillator();
  engine.type="sawtooth";
  engine.frequency.value=65;

  engineGain=audio.createGain();
  engineGain.gain.value=.001;

  engine.connect(engineGain);
  engineGain.connect(master);
  engine.start();
  audioReady=true;
 }catch(e){}
}

function beep(freq,duration,type="square"){
 if(!audioReady)return;

 const osc=audio.createOscillator();
 const gain=audio.createGain();

 osc.type=type;
 osc.frequency.value=freq;
 gain.gain.setValueAtTime(.2,audio.currentTime);
 gain.gain.exponentialRampToValueAtTime(
  .001,audio.currentTime+duration
 );

 osc.connect(gain);
 gain.connect(master);

 osc.start();
 osc.stop(audio.currentTime+duration);
}

function updateSound(){
 if(!audioReady)return;

 engine.frequency.setTargetAtTime(
  55+speed*2,audio.currentTime,.08
 );

 engineGain.gain.setTargetAtTime(
  playing?.025:.001,audio.currentTime,.1
 );
}

function startGame(){
 initSound();
 if(audio&&audio.state==="suspended")audio.resume();

 playing=true;
 document.getElementById("menu").style.display="none";

 beep(650,.15,"sine");
}

document.getElementById("start").onclick=startGame;

function drawSky(){
 const g=ctx.createLinearGradient(0,0,0,H*.5);
 g.addColorStop(0,"#3985b5");
 g.addColorStop(.6,"#f2c58a");
 g.addColorStop(1,"#f5dfb6");

 ctx.fillStyle=g;
 ctx.fillRect(0,0,W,H);

 ctx.fillStyle="#ffe3a4";
 ctx.beginPath();
 ctx.arc(W*.8,H*.18,30,0,Math.PI*2);
 ctx.fill();

 // أفق بغداد ومبانيها
 for(let i=0;i<20;i++){
  const x=i*W/18;
  const bw=20+(i*13%30);
  const bh=35+(i*29%75);

  ctx.fillStyle=["#b7a38a","#8b938e","#d0b99a"][i%3];
  ctx.fillRect(x,H*.34-bh,bw,bh);

  ctx.fillStyle="#596b6c";
  for(let y=H*.34-bh+8;y<H*.33;y+=12){
   for(let xx=x+5;xx<x+bw-3;xx+=9){
    ctx.fillRect(xx,y,4,5);
   }
  }
 }

 // نصب السيوف بشكل رمزي
 ctx.strokeStyle="#6c6b64";
 ctx.lineWidth=5;
 ctx.beginPath();
 ctx.moveTo(W*.7,H*.32);
 ctx.lineTo(W*.76,H*.2);
 ctx.lineTo(W*.82,H*.32);
 ctx.moveTo(W*.72,H*.32);
 ctx.lineTo(W*.76,H*.22);
 ctx.lineTo(W*.8,H*.32);
 ctx.stroke();
}

function drawRiver(){
 ctx.fillStyle="#3b9ba8";
 ctx.beginPath();
 ctx.moveTo(0,H*.48);
 ctx.lineTo(W,H*.43);
 ctx.lineTo(W,H*.68);
 ctx.lineTo(0,H*.72);
 ctx.closePath();
 ctx.fill();

 ctx.strokeStyle="#b9e4d6";
 ctx.globalAlpha=.35;

 for(let i=0;i<12;i++){
  const y=H*.48+i*H*.015;
  ctx.beginPath();
  ctx.moveTo(W*.05,y);
  ctx.lineTo(W*.95,y);
  ctx.stroke();
 }
 ctx.globalAlpha=1;
}

function roadEdges(y){
 const t=(y-H*.32)/(H*.68);
 return{
  center:W*.5+Math.sin(roadMove*.002)*W*.02*t,
  half:W*(.12+.39*t),
  t:t
 };
}

function drawRoad(){
 const top=H*.32;
 const bottom=H+20;

 const a=roadEdges(top);
 const b=roadEdges(bottom);

 // الطريق
 ctx.fillStyle="#343a3e";
 ctx.beginPath();
 ctx.moveTo(a.center-a.half,top);
 ctx.lineTo(a.center+a.half,top);
 ctx.lineTo(b.center+b.half,bottom);
 ctx.lineTo(b.center-b.half,bottom);
 ctx.closePath();
 ctx.fill();

 // حافات الطريق
 ctx.strokeStyle="#f1d8a0";
 ctx.lineWidth=4;
 ctx.beginPath();
 ctx.moveTo(a.center-a.half,top);
 ctx.lineTo(b.center-b.half,bottom);
 ctx.moveTo(a.center+a.half,top);
 ctx.lineTo(b.center+b.half,bottom);
 ctx.stroke();

 // خطوط المسارات المتحركة
 for(let i=0;i<14;i++){
  let z=((i/14+roadMove*.0008)%1);
  let y=top+z*(H-top);
  let r=roadEdges(y);
  let size=2+z*4;
  let dash=5+z*25;

  ctx.fillStyle="#eee9d4";
  ctx.fillRect(r.center-r.half/3-size/2,y,size,dash);
  ctx.fillRect(r.center+r.half/3-size/2,y,size,dash);
 }
}

function drawPalms(){
 for(let i=0;i<10;i++){
  let z=((i/10+roadMove*.00012)%1);
  let y=H*.33+z*H*.55;
  let t=(y-H*.32)/(H*.68);
  let scale=.3+t;

  for(const side of [-1,1]){
   let x=W*.5+side*(W*.17+t*W*.37);

   ctx.strokeStyle="#62492f";
   ctx.lineWidth=4*scale;
   ctx.beginPath();
   ctx.moveTo(x,y);
   ctx.lineTo(x-2*scale,y-22*scale);
   ctx.stroke();

   ctx.fillStyle="#267446";
   for(let k=0;k<6;k++){
    ctx.beginPath();
    ctx.ellipse(
     x+Math.cos(k*1.1)*10*scale,
     y-23*scale+Math.sin(k*1.1)*5*scale,
     11*scale,3*scale,k*.5,0,Math.PI*2
    );
    ctx.fill();
   }
  }
 }
}

function drawSign(){
 const x=W*.04;
 const y=H*.37;

 ctx.fillStyle="#426447";
 ctx.fillRect(x,y,110,43);

 ctx.strokeStyle="#f4e7c9";
 ctx.lineWidth=2;
 ctx.strokeRect(x,y,110,43);

 ctx.fillStyle="white";
 ctx.textAlign="center";
 ctx.font="bold 14px Tahoma";
 ctx.fillText("بغداد",x+55,y+18);

 ctx.font="11px Arial";
 ctx.fillText("BAGHDAD ↑",x+55,y+34);
}

function drawCar(x,y,w,h,color,player=false){
 ctx.save();
 ctx.translate(x,y);

 // ظل السيارة
 ctx.fillStyle="#0005";
 ctx.beginPath();
 ctx.ellipse(0,h*.35,w*.65,h*.18,0,0,Math.PI*2);
 ctx.fill();

 // الإطارات
 ctx.fillStyle="#101215";
 ctx.fillRect(-w*.53,-h*.2,w*.17,h*.35);
 ctx.fillRect(w*.36,-h*.2,w*.17,h*.35);
 ctx.fillRect(-w*.53,h*.18,w*.17,h*.3);
 ctx.fillRect(w*.36,h*.18,w*.17,h*.3);

 // جسم السيارة
 const grad=ctx.createLinearGradient(-w/2,0,w/2,0);
 grad.addColorStop(0,"#101418");
 grad.addColorStop(.4,color);
 grad.addColorStop(1,"#101418");

 ctx.fillStyle=grad;
 ctx.beginPath();
 ctx.moveTo(-w*.42,h*.4);
 ctx.lineTo(-w*.5,-h*.15);
 ctx.quadraticCurveTo(-w*.5,-h*.42,-w*.25,-h*.46);
 ctx.lineTo(w*.25,-h*.46);
 ctx.quadraticCurveTo(w*.5,-h*.42,w*.5,-h*.15);
 ctx.lineTo(w*.42,h*.4);
 ctx.closePath();
 ctx.fill();

 // الزجاج الخلفي
 ctx.fillStyle="#8cbac7";
 ctx.beginPath();
 ctx.moveTo(-w*.3,-h*.17);
 ctx.lineTo(-w*.22,-h*.37);
 ctx.lineTo(w*.22,-h*.37);
 ctx.lineTo(w*.3,-h*.17);
 ctx.closePath();
 ctx.fill();

 // الزجاج السفلي
 ctx.fillStyle="#253d47";
 ctx.fillRect(-w*.3,h*.02,w*.6,h*.15);

 // الأنوار
 ctx.fillStyle="#ff3434";
 ctx.fillRect(-w*.4,h*.26,w*.18,h*.09);
 ctx.fillRect(w*.22,h*.26,w*.18,h*.09);

 if(player){
  ctx.fillStyle="#e9edf0";
  ctx.fillRect(-w*.2,h*.16,w*.4,h*.08);

  ctx.fillStyle="#111";
  ctx.textAlign="center";
  ctx.font="bold "+Math.max(5,w*.09)+"px Arial";
  ctx.fillText("IRAQ",0,h*.22);
 }

 ctx.restore();
}

const traffic=[];

function drawTraffic(dt){
 if(Math.random()<.012&&traffic.length<6){
  traffic.push({
   lane:Math.random()*1.2-.6,
   z:.1,
   color:["#ddd8cc","#b43a2e","#bfc8ce","#d4a43c"][Math.floor(Math.random()*4)],
   v:.1+Math.random()*.2
  });
 }

 for(let i=traffic.length-1;i>=0;i--){
  const c=traffic[i];
  c.z+=dt*(.08+c.v+speed*.0007);

  if(c.z>1.1){
   traffic.splice(i,1);
   continue;
  }

  const y=H*.32+c.z*H*.7;
  const r=roadEdges(y);
  const x=r.center+c.lane*r.half;

  drawCar(x,y,12+c.z*30,22+c.z*45,c.color);
 }
}

function drawPlayer(){
 const r=roadEdges(H*.83);
 const x=r.center+lane*r.half*.65;
 const w=Math.min(W*.23,100);
 const h=w*1.45;

 drawCar(x,H*.82,w,h,"#101820",true);
}

function update(dt){
 if(!playing)return;

 if(keys.gas)speed=Math.min(180,speed+45*dt);
 else speed=Math.max(0,speed-7*dt);

 if(keys.brake)speed=Math.max(0,speed-80*dt);

 if(keys.left)steering=Math.max(-1,steering-3*dt);
 else if(keys.right)steering=Math.min(1,steering+3*dt);
 else steering*=Math.pow(.04,dt);

 lane=Math.max(-.8,Math.min(.8,lane+steering*dt*(.7+speed/100)));

 roadMove+=speed*dt*8;
 distance+=speed*dt/3.6;

 document.getElementById("speed").textContent=Math.round(speed);
 document.getElementById("distance").textContent=Math.floor(distance);

 updateSound();
}

function draw(dt){
 ctx.clearRect(0,0,W,H);

 drawSky();
 drawRiver();
 drawPalms();
 drawRoad();
 drawSign();
 drawTraffic(dt);
 drawPlayer();
}

function loop(time){
 if(!last)last=time;

 const dt=Math.min((time-last)/1000,.04);
 last=time;

 update(dt);
 draw(dt);

 requestAnimationFrame(loop);
}

document.querySelectorAll("[data-key]").forEach(btn=>{
 const key=btn.dataset.key;

 function down(e){
  e.preventDefault();
  keys[key]=true;
  btn.classList.add("active");

  if(!playing&&key==="gas")startGame();
 }

 function up(e){
  e.preventDefault();
  keys[key]=false;
  btn.classList.remove("active");
 }

 btn.addEventListener("pointerdown",down);
 btn.addEventListener("pointerup",up);
 btn.addEventListener("pointercancel",up);
 btn.addEventListener("pointerleave",up);
});

document.getElementById("horn").addEventListener("pointerdown",e=>{
 e.preventDefault();
 initSound();

 if(audio&&audio.state==="suspended")audio.resume();

 beep(390,.4,"sawtooth");
 setTimeout(()=>beep(520,.3,"square"),60);
});

addEventListener("keydown",e=>{
 const map={
  ArrowLeft:"left",
  ArrowRight:"right",
  ArrowUp:"gas",
  ArrowDown:"brake"
 };

 if(map[e.key]){
  keys[map[e.key]]=true;
  e.preventDefault();
 }

 if(e.key==="Enter"&&!playing)startGame();
});

addEventListener("keyup",e=>{
 const map={
  ArrowLeft:"left",
  ArrowRight:"right",
  ArrowUp:"gas",
  ArrowDown:"brake"
 };

 if(map[e.key])keys[map[e.key]]=false;
});

document.addEventListener("visibilitychange",()=>{
 if(document.hidden){
  Object.keys(keys).forEach(k=>keys[k]=false);
 }
});

requestAnimationFrame(loop);
</script>
</body>
</html>