import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(const IraqGameApp());

class IraqGameApp extends StatelessWidget {
  const IraqGameApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'شوارع العراق - علاوي ال حمادي',
      theme: ThemeData.dark(),
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF000000))
      ..loadHtmlString(_html);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }
}

const String _html = r'''
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no,viewport-fit=cover">
<title>شوارع العراق | علاوي ال حمادي</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;-webkit-tap-highlight-color:transparent;}
html,body{width:100%;height:100%;overflow:hidden;background:#000;font-family:'Segoe UI',Tahoma,Arial,sans-serif;user-select:none;-webkit-user-select:none;}
#game{position:fixed;inset:0;}
canvas{display:block;}
#menu{position:fixed;inset:0;z-index:200;background:linear-gradient(165deg,#07131c 0%,#0f2027 35%,#203a43 70%,#2c5364 100%);display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;color:#fff;padding:18px;transition:opacity .7s ease;overflow-y:auto;}
#menu.hide{opacity:0;pointer-events:none;}
.flagbar{display:flex;height:9px;width:190px;border-radius:6px;overflow:hidden;margin-bottom:16px;box-shadow:0 0 22px rgba(255,255,255,.25);}
.flagbar div{flex:1;}
.f1{background:#CE1126}.f2{background:#fff}.f3{background:#000}
#menu h1{font-size:clamp(34px,10vw,68px);color:#ffd700;font-weight:900;text-shadow:0 0 26px rgba(255,215,0,.7),0 5px 0 #8a6d00;margin-bottom:6px;}
#menu .sub{font-size:clamp(13px,3.6vw,18px);color:#9fd4ff;margin-bottom:4px;}
#menu .sub2{font-size:clamp(11px,3vw,15px);color:#ffb86b;margin-bottom:20px;}
#startBtn{background:linear-gradient(180deg,#ffd700,#e6a800);color:#1a1206;border:none;border-radius:60px;padding:16px 52px;font-size:clamp(18px,5vw,24px);font-weight:900;cursor:pointer;box-shadow:0 8px 0 #8a6d00,0 12px 30px rgba(255,215,0,.4);font-family:inherit;margin-bottom:18px;}
#startBtn:active{transform:translateY(5px);box-shadow:0 3px 0 #8a6d00;}
.helpbox{background:rgba(255,255,255,.07);border:1px solid rgba(255,255,255,.15);border-radius:14px;padding:12px 18px;font-size:clamp(11px,3vw,14px);color:#cfe8ff;line-height:1.9;max-width:420px;margin-bottom:18px;}
.devbox{border:2px solid #ffd700;border-radius:14px;padding:12px 22px;background:rgba(255,215,0,.08);margin-bottom:8px;}
.devbox .lbl{font-size:11px;color:#9fd4ff;letter-spacing:2px;margin-bottom:4px;}
.devbox .name{font-size:clamp(17px,4.6vw,24px);font-weight:900;color:#ffd700;}
.devbox .phone{font-size:clamp(15px,4vw,20px);font-weight:700;color:#fff;direction:ltr;letter-spacing:1px;margin-top:3px;}
.credit{font-size:11px;color:#5f7d94;margin-top:10px;}
#hud{position:fixed;inset:0;z-index:50;pointer-events:none;display:none;}
#hud.on{display:block;}
#speedo{position:absolute;bottom:16px;left:50%;transform:translateX(-50%);background:rgba(0,0,0,.55);border:2px solid rgba(255,215,0,.6);border-radius:16px;padding:6px 20px;text-align:center;color:#fff;backdrop-filter:blur(6px);min-width:120px;}
#speedVal{font-size:30px;font-weight:900;color:#ffd700;line-height:1;direction:ltr;}
#speedUnit{font-size:10px;color:#9fd4ff;letter-spacing:2px;}
#devTag{position:absolute;top:10px;right:10px;background:rgba(0,0,0,.5);border:1px solid rgba(255,215,0,.5);border-radius:10px;padding:6px 12px;text-align:right;backdrop-filter:blur(6px);}
#devTag .n{font-size:12px;font-weight:900;color:#ffd700;}
#devTag .p{font-size:11px;color:#fff;direction:ltr;}
#hornBtn{position:absolute;top:10px;left:10px;pointer-events:auto;width:58px;height:58px;border-radius:50%;background:rgba(255,215,0,.18);border:2px solid #ffd700;color:#ffd700;font-size:24px;display:flex;align-items:center;justify-content:center;cursor:pointer;backdrop-filter:blur(6px);}
#hornBtn:active{background:rgba(255,215,0,.5);}
#dialogue{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%) scale(.85);background:rgba(0,0,0,.78);border:2px solid #ffd700;border-radius:18px;padding:14px 26px;color:#fff;font-size:clamp(15px,4.2vw,22px);font-weight:700;max-width:88vw;text-align:center;opacity:0;transition:all .35s ease;box-shadow:0 0 34px rgba(255,215,0,.35);backdrop-filter:blur(8px);line-height:1.6;}
#dialogue.show{opacity:1;transform:translate(-50%,-50%) scale(1);}
#touch{position:fixed;inset:0;z-index:60;pointer-events:none;display:none;}
#touch.on{display:block;}
.tbtn{position:absolute;pointer-events:auto;background:rgba(255,255,255,.13);border:2px solid rgba(255,255,255,.4);border-radius:22px;color:#fff;font-size:30px;font-weight:900;display:flex;align-items:center;justify-content:center;backdrop-filter:blur(4px);touch-action:none;}
.tbtn:active,.tbtn.press{background:rgba(255,215,0,.55);border-color:#ffd700;}
#btnLeft{left:14px;bottom:100px;width:76px;height:76px;}
#btnRight{left:104px;bottom:100px;width:76px;height:76px;}
#btnGas{right:14px;bottom:100px;width:86px;height:86px;font-size:26px;background:rgba(60,200,90,.25);border-color:rgba(60,220,90,.7);}
#btnBrake{right:110px;bottom:100px;width:76px;height:76px;font-size:24px;background:rgba(220,60,60,.25);border-color:rgba(255,80,80,.7);}
#loader{position:fixed;inset:0;z-index:300;background:#0f2027;display:flex;align-items:center;justify-content:center;flex-direction:column;color:#ffd700;font-size:20px;font-weight:900;gap:16px;}
.spin{width:52px;height:52px;border:5px solid rgba(255,215,0,.2);border-top-color:#ffd700;border-radius:50%;animation:sp 1s linear infinite;}
@keyframes sp{to{transform:rotate(360deg);}}
</style>
</head>
<body>
<div id="loader"><div class="spin"></div><div>جاري تحميل شوارع العراق...</div></div>
<div id="menu">
  <div class="flagbar"><div class="f1"></div><div class="f2"></div><div class="f3"></div></div>
  <h1>شوارع العراق</h1>
  <div class="sub">🚗 لعبة سيارات — عالم مفتوح 🇮🇶</div>
  <div class="sub2">سوّگ بالشوارع وسمع الدريفر العراقي يحچي!</div>
  <button id="startBtn">🏁 ابدأ السواقة</button>
  <div class="helpbox">📱 <b>للموبايل:</b> استخدم الأزرار على الشاشة<br>⌨️ <b>للكمبيوتر:</b> الأسهم أو WASD<br>🔊 <b>H</b> = البوق &nbsp;|&nbsp; <b>R</b> = رجّع السيارة</div>
  <div class="devbox">
    <div class="lbl">تطوير وتصميم</div>
    <div class="name">علاوي ال حمادي</div>
    <div class="phone">07880254887</div>
  </div>
  <div class="credit">© جميع الحقوق محفوظة — علاوي ال حمادي</div>
</div>
<div id="game"></div>
<div id="hud">
  <div id="speedo"><div id="speedVal">0</div><div id="speedUnit">KM/H</div></div>
  <div id="devTag"><div class="n">علاوي ال حمادي</div><div class="p">07880254887</div></div>
  <div id="hornBtn">📢</div>
  <div id="dialogue"></div>
</div>
<div id="touch">
  <div class="tbtn" id="btnLeft">◀</div>
  <div class="tbtn" id="btnRight">▶</div>
  <div class="tbtn" id="btnGas">⛽</div>
  <div class="tbtn" id="btnBrake">🛑</div>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
<script>
let scene,camera,renderer,clock,car,driverGroup,wheels=[],frontWheels=[],obstacles=[];
let carState={speed:0,angle:0,steer:0};
let keys={f:false,b:false,l:false,r:false};
let gameStarted=false,dialogueTimer=null,quoteTimer=0,nextQuoteIn=6;
let audioCtx=null,engineOsc=null,engineGain=null,engineFilter=null;
const WORLD=420,ROAD_LINES=[-160,-80,0,80,160],ROAD_HALF=9,BLOCK_CENTERS=[-120,-40,40,120];
const IRAQI_QUOTES=["يا هو! شفت شلون أسوگ؟ 😎","هذا الشارع أعرفه من وأنا صغير!","شگد حلو جو العراق 🇮🇶","الله يخلي العراق وأهل العراق","سلام عليكم... وين رايحين؟","البنزين غالي هاليومين والله ⛽","شنو رأيك نروح نجيب چاي؟ ☕","هيه! دير بالك عالطريق 🚧","بغداد يا بغداد... 🌴","أنا علاوي، أشهر درايفر بالعراق! 🏆","شوف هالبناية شگد حلوة!","يمعود... الطريق مزدحم اليوم","شلونك عمو؟ اشلون الحال؟","هاي السيارة ما شاء الله عليها 🔥","تعال اركب! نروح نتمشى","الله أكبر... شوف هالمنظر!","الدنيا عراقية والجو يخبل 🌤️","شنو هالحفرة بالطريق؟! 😤"];
function initAudio(){try{const AC=window.AudioContext||window.webkitAudioContext;audioCtx=new AC();engineGain=audioCtx.createGain();engineGain.gain.value=0;engineGain.connect(audioCtx.destination);engineFilter=audioCtx.createBiquadFilter();engineFilter.type='lowpass';engineFilter.frequency.value=500;engineFilter.connect(engineGain);engineOsc=audioCtx.createOscillator();engineOsc.type='sawtooth';engineOsc.frequency.value=55;engineOsc.connect(engineFilter);engineOsc.start();}catch(e){console.log(e);}}
function updateEngineSound(){if(!audioCtx||!engineOsc)return;const spd=Math.abs(carState.speed);engineOsc.frequency.setTargetAtTime(50+spd*5.5,audioCtx.currentTime,0.1);engineFilter.frequency.setTargetAtTime(350+spd*45,audioCtx.currentTime,0.1);const vol=gameStarted?(keys.f?0.055:0.025):0;engineGain.gain.setTargetAtTime(vol,audioCtx.currentTime,0.15);}
function playHorn(){if(!audioCtx)return;const t=audioCtx.currentTime;[420,565].forEach(f=>{const o=audioCtx.createOscillator();const g=audioCtx.createGain();o.type='square';o.frequency.value=f;g.gain.setValueAtTime(0.0001,t);g.gain.exponentialRampToValueAtTime(0.11,t+0.02);g.gain.exponentialRampToValueAtTime(0.0001,t+0.5);o.connect(g);g.connect(audioCtx.destination);o.start(t);o.stop(t+0.55);});showDialogue('بييييب! 📢🚗💨',1600);}
function makeSkyTexture(){const c=document.createElement('canvas');c.width=16;c.height=256;const g=c.getContext('2d');const gr=g.createLinearGradient(0,0,0,256);gr.addColorStop(0,'#1b5b96');gr.addColorStop(0.35,'#5fa8dd');gr.addColorStop(0.62,'#a8d2ee');gr.addColorStop(0.85,'#e6d6ae');gr.addColorStop(1,'#f0e0b8');g.fillStyle=gr;g.fillRect(0,0,16,256);return new THREE.CanvasTexture(c);}
function makeBuildingTexture(base,win){const c=document.createElement('canvas');c.width=64;c.height=64;const g=c.getContext('2d');g.fillStyle=base;g.fillRect(0,0,64,64);g.fillStyle='rgba(0,0,0,0.06)';g.fillRect(0,0,64,4);for(let y=8;y<60;y+=14){for(let x=6;x<58;x+=14){g.fillStyle=Math.random()>0.25?win:'rgba(20,25,35,0.9)';g.fillRect(x,y,9,8);g.fillStyle='rgba(255,255,255,0.15)';g.fillRect(x,y,9,2);}}const t=new THREE.CanvasTexture(c);t.wrapS=t.wrapT=THREE.RepeatWrapping;return t;}
function makeRoadTexture(h){const c=document.createElement('canvas');c.width=64;c.height=64;const g=c.getContext('2d');g.fillStyle='#3a3a3d';g.fillRect(0,0,64,64);for(let i=0;i<300;i++){g.fillStyle='rgba(255,255,255,'+(Math.random()*0.05)+')';g.fillRect(Math.random()*64,Math.random()*64,1,1);}g.fillStyle='#e8e8e0';if(h){g.fillRect(0,30,26,4);g.fillRect(0,3,64,2);g.fillRect(0,59,64,2);}else{g.fillRect(30,0,4,26);g.fillRect(3,0,2,64);g.fillRect(59,0,2,64);}const t=new THREE.CanvasTexture(c);t.wrapS=t.wrapT=THREE.RepeatWrapping;return t;}
function makeShmaghTexture(){const c=document.createElement('canvas');c.width=32;c.height=32;const g=c.getContext('2d');g.fillStyle='#ffffff';g.fillRect(0,0,32,32);g.fillStyle='#b52d2d';for(let y=0;y<32;y+=8){for(let x=0;x<32;x+=8){g.fillRect(x,y,3,3);g.fillRect(x+4,y+4,2,2);}}const t=new THREE.CanvasTexture(c);t.wrapS=t.wrapT=THREE.RepeatWrapping;t.repeat.set(2,2);return t;}
function makeFlagTexture(){const c=document.createElement('canvas');c.width=192;c.height=128;const g=c.getContext('2d');g.fillStyle='#CE1126';g.fillRect(0,0,192,42.7);g.fillStyle='#FFFFFF';g.fillRect(0,42.7,192,85.3);g.fillStyle='#000000';g.fillRect(0,85.3,192,42.7);g.fillStyle='#007A3D';g.font='bold 26px Tahoma';g.textAlign='center';g.fillText('الله أكبر',96,80);return new THREE.CanvasTexture(c);}
function buildSky(){scene.add(new THREE.Mesh(new THREE.SphereGeometry(600,24,16),new THREE.MeshBasicMaterial({map:makeSkyTexture(),side:THREE.BackSide,fog:false})));const sun=new THREE.Mesh(new THREE.SphereGeometry(18,16,12),new THREE.MeshBasicMaterial({color:0xfff4c0,fog:false}));sun.position.set(-260,180,-320);scene.add(sun);}
function buildGround(){const g=new THREE.Mesh(new THREE.PlaneGeometry(WORLD*2.4,WORLD*2.4),new THREE.MeshLambertMaterial({color:0xc9b184}));g.rotation.x=-Math.PI/2;g.position.y=-0.02;scene.add(g);}
function buildRoads(){const tNS=makeRoadTexture(false);tNS.repeat.set(1,42);const tEW=makeRoadTexture(true);tEW.repeat.set(42,1);const mNS=new THREE.MeshLambertMaterial({map:tNS});const mEW=new THREE.MeshLambertMaterial({map:tEW});const len=WORLD*2;ROAD_LINES.forEach(x=>{const m=new THREE.Mesh(new THREE.PlaneGeometry(ROAD_HALF*2,len),mNS);m.rotation.x=-Math.PI/2;m.position.set(x,0.02,0);scene.add(m);});ROAD_LINES.forEach(z=>{const m=new THREE.Mesh(new THREE.PlaneGeometry(len,ROAD_HALF*2),mEW);m.rotation.x=-Math.PI/2;m.position.set(0,0.018,z);scene.add(m);});}
function buildBuilding(x,z,w,d,h){const cols=[['#d9c9a8','rgba(70,110,150,0.85)'],['#c8b393','rgba(60,90,130,0.85)'],['#e2d6bb','rgba(80,120,160,0.85)'],['#bfa887','rgba(50,70,100,0.9)'],['#d4bfa0','rgba(90,130,170,0.8)'],['#e8dcc4','rgba(70,100,140,0.85)']];const p=cols[Math.floor(Math.random()*cols.length)];const tex=makeBuildingTexture(p[0],p[1]);tex.repeat.set(Math.max(1,Math.round(w/7)),Math.max(1,Math.round(h/7)));const m=new THREE.Mesh(new THREE.BoxGeometry(w,h,d),new THREE.MeshLambertMaterial({map:tex}));m.position.set(x,h/2,z);scene.add(m);const r=new THREE.Mesh(new THREE.BoxGeometry(w+0.5,0.6,d+0.5),new THREE.MeshLambertMaterial({color:0xa8977a}));r.position.set(x,h+0.3,z);scene.add(r);if(Math.random()>0.4){const tk=new THREE.Mesh(new THREE.CylinderGeometry(1.1,1.1,1.8,8),new THREE.MeshLambertMaterial({color:0xdadada}));tk.position.set(x+(Math.random()-0.5)*w*0.5,h+1.5,z+(Math.random()-0.5)*d*0.5);scene.add(tk);}obstacles.push({minX:x-w/2,maxX:x+w/2,minZ:z-d/2,maxZ:z+d/2});}
function buildMosque(cx,cz){const g=new THREE.Group();const bM=new THREE.MeshLambertMaterial({color:0xefe6cf});const dM=new THREE.MeshLambertMaterial({color:0xd4af37});const base=new THREE.Mesh(new THREE.BoxGeometry(34,14,34),bM);base.position.y=7;g.add(base);const dome=new THREE.Mesh(new THREE.SphereGeometry(9,20,14,0,Math.PI*2,0,Math.PI/2),dM);dome.position.y=14;g.add(dome);const cr=new THREE.Mesh(new THREE.TorusGeometry(1.6,0.35,8,16,Math.PI*1.5),new THREE.MeshLambertMaterial({color:0xffd700}));cr.position.y=24.5;cr.rotation.z=-Math.PI/3;g.add(cr);const mn=new THREE.Mesh(new THREE.CylinderGeometry(2.2,3,34,10),bM);mn.position.set(19,17,19);g.add(mn);const md=new THREE.Mesh(new THREE.SphereGeometry(2.8,14,10),dM);md.position.set(19,34.5,19);g.add(md);const mt=new THREE.Mesh(new THREE.ConeGeometry(1.2,4,8),new THREE.MeshLambertMaterial({color:0xffd700}));mt.position.set(19,38,19);g.add(mt);[-14,14].forEach(dx=>{const p=new THREE.Mesh(new THREE.CylinderGeometry(0.25,0.25,16,8),new THREE.MeshLambertMaterial({color:0x888888}));p.position.set(dx,8,18);g.add(p);const f=new THREE.Mesh(new THREE.PlaneGeometry(6,4),new THREE.MeshBasicMaterial({map:makeFlagTexture(),side:THREE.DoubleSide}));f.position.set(dx+3,13.5,18);g.add(f);});g.position.set(cx,0,cz);scene.add(g);obstacles.push({minX:cx-17,maxX:cx+17,minZ:cz-17,maxZ:cz+17});}
function buildPalm(x,z){const g=new THREE.Group();const tr=new THREE.Mesh(new THREE.CylinderGeometry(0.28,0.45,7,7),new THREE.MeshLambertMaterial({color:0x8a6a45}));tr.position.y=3.5;g.add(tr);const lM=new THREE.MeshLambertMaterial({color:0x2f7d32,side:THREE.DoubleSide});const lG=new THREE.ConeGeometry(0.7,4.2,4);for(let i=0;i<8;i++){const h=new THREE.Group();const l=new THREE.Mesh(lG,lM);l.rotation.z=-Math.PI/2-0.35;l.position.x=2;h.add(l);h.rotation.y=(i/8)*Math.PI*2;h.rotation.z=0.12;h.position.y=7;g.add(h);}const dt=new THREE.Mesh(new THREE.SphereGeometry(0.7,8,6),new THREE.MeshLambertMaterial({color:0xb5651d}));dt.position.y=6.6;g.add(dt);g.position.set(x,0,z);g.rotation.y=Math.random()*Math.PI*2;scene.add(g);}
function buildBillboard(){const g=new THREE.Group();const pM=new THREE.MeshLambertMaterial({color:0x707070});[-10.5,10.5].forEach(dx=>{const p=new THREE.Mesh(new THREE.CylinderGeometry(0.35,0.45,11,8),pM);p.position.set(dx,5.5,0);g.add(p);});const c=document.createElement('canvas');c.width=1024;c.height=340;const ctx=c.getContext('2d');ctx.fillStyle='#0b2b4a';ctx.fillRect(0,0,1024,340);ctx.strokeStyle='#ffd700';ctx.lineWidth=12;ctx.strokeRect(12,12,1000,316);ctx.textAlign='center';ctx.fillStyle='#ffd700';ctx.font='bold 88px Tahoma';ctx.fillText('علاوي ال حمادي',512,118);ctx.fillStyle='#ffffff';ctx.font='bold 72px Tahoma';ctx.direction='ltr';ctx.fillText('07880254887',512,210);ctx.fillStyle='#7ec8ff';ctx.font='bold 50px Tahoma';ctx.fillText('شوارع العراق - لعبة سيارات',512,292);const tex=new THREE.CanvasTexture(c);const b=new THREE.Mesh(new THREE.PlaneGeometry(22,7.3),new THREE.MeshBasicMaterial({map:tex,side:THREE.DoubleSide}));b.position.set(0,13.5,0);g.add(b);g.position.set(0,0,42);scene.add(g);}
function buildCity(){BLOCK_CENTERS.forEach(bx=>{BLOCK_CENTERS.forEach(bz=>{if(bx===40&&bz===40){buildMosque(bx,bz);return;}for(let i=0;i<2;i++){for(let j=0;j<2;j++){const cx=bx+(i?15:-15);const cz=bz+(j?15:-15);buildBuilding(cx,cz,17+Math.random()*9,17+Math.random()*9,9+Math.random()*34);}}});});for(let i=0;i<70;i++){const side=Math.random()>0.5?1:-1;const onX=Math.random()>0.5;const road=ROAD_LINES[Math.floor(Math.random()*ROAD_LINES.length)];const along=(Math.random()-0.5)*WORLD*1.6;let x,z;if(onX){x=road+side*10.6;z=along;}else{x=along;z=road+side*10.6;}let ok=true;for(const o of obstacles){if(x>o.minX-2&&x<o.maxX+2&&z>o.minZ-2&&z<o.maxZ+2){ok=false;break;}}if(ok)buildPalm(x,z);}[[11,-30,0],[11,-50,0],[-11,25,Math.PI],[-11,60,Math.PI],[25,11,Math.PI/2],[60,11,Math.PI/2],[-30,-11,-Math.PI/2],[-60,-11,-Math.PI/2],[11,120,0],[-11,-120,Math.PI]].forEach(p=>buildParkedCar(p[0],p[1],p[2]));buildBillboard();}
function buildParkedCar(x,z,r){const cols=[0x2c3e50,0x8e44ad,0xc0392b,0x27ae60,0x2980b9,0xecf0f1,0x7f8c8d];const col=cols[Math.floor(Math.random()*cols.length)];const g=new THREE.Group();const b=new THREE.Mesh(new THREE.BoxGeometry(1.9,0.75,4.2),new THREE.MeshLambertMaterial({color:col}));b.position.y=0.78;g.add(b);const c=new THREE.Mesh(new THREE.BoxGeometry(1.7,0.62,2.0),new THREE.MeshLambertMaterial({color:0x1c2b38,transparent:true,opacity:0.85}));c.position.set(0,1.45,-0.15);g.add(c);const wM=new THREE.MeshLambertMaterial({color:0x111111});const wG=new THREE.CylinderGeometry(0.4,0.4,0.3,12);[[-0.95,1.35],[0.95,1.35],[-0.95,-1.35],[0.95,-1.35]].forEach(p=>{const w=new THREE.Mesh(wG,wM);w.rotation.z=Math.PI/2;w.position.set(p[0],0.4,p[1]);g.add(w);});g.position.set(x,0,z);g.rotation.y=r;scene.add(g);const rad=2.2;obstacles.push({minX:x-rad,maxX:x+rad,minZ:z-rad,maxZ:z+rad});}
function buildCar(){car=new THREE.Group();const bM=new THREE.MeshLambertMaterial({color:0xf5f5f0});const gM=new THREE.MeshLambertMaterial({color:0x9fd4ff,transparent:true,opacity:0.28,side:THREE.DoubleSide});const cM=new THREE.MeshLambertMaterial({color:0xd0d0d0});const ch=new THREE.Mesh(new THREE.BoxGeometry(2.0,0.55,4.4),bM);ch.position.y=0.78;car.add(ch);const hd=new THREE.Mesh(new THREE.BoxGeometry(1.9,0.28,1.7),bM);hd.position.set(0,1.14,1.25);car.add(hd);const tk=new THREE.Mesh(new THREE.BoxGeometry(1.9,0.28,1.3),bM);tk.position.set(0,1.14,-1.5);car.add(tk);[-0.93,0.93].forEach(dx=>{const s=new THREE.Mesh(new THREE.BoxGeometry(0.14,0.5,2.1),bM);s.position.set(dx,1.28,-0.15);car.add(s);});const bk=new THREE.Mesh(new THREE.BoxGeometry(2.0,0.5,0.14),bM);bk.position.set(0,1.28,-1.2);car.add(bk);const ws=new THREE.Mesh(new THREE.BoxGeometry(1.85,0.62,0.08),gM);ws.position.set(0,1.62,0.9);ws.rotation.x=-0.28;car.add(ws);const bMt=new THREE.MeshLambertMaterial({color:0x333333});const bar=new THREE.Mesh(new THREE.BoxGeometry(1.9,0.12,0.12),bMt);bar.position.set(0,1.85,0.7);car.add(bar);[-0.9,0.9].forEach(dx=>{const l=new THREE.Mesh(new THREE.BoxGeometry(0.11,0.62,0.11),bMt);l.position.set(dx,1.55,0.7);car.add(l);});const lM=new THREE.MeshBasicMaterial({color:0xfff2b0});[-0.65,0.65].forEach(dx=>{const l=new THREE.Mesh(new THREE.BoxGeometry(0.45,0.2,0.12),lM);l.position.set(dx,0.95,2.2);car.add(l);});const tM=new THREE.MeshBasicMaterial({color:0xff3b30});[-0.7,0.7].forEach(dx=>{const l=new THREE.Mesh(new THREE.BoxGeometry(0.4,0.18,0.1),tM);l.position.set(dx,0.98,-2.22);car.add(l);});const bf=new THREE.Mesh(new THREE.BoxGeometry(2.05,0.28,0.25),cM);bf.position.set(0,0.6,2.2);car.add(bf);const bb=new THREE.Mesh(new THREE.BoxGeometry(2.05,0.28,0.25),cM);bb.position.set(0,0.6,-2.2);car.add(bb);const wGeo=new THREE.CylinderGeometry(0.44,0.44,0.34,14);const wMat=new THREE.MeshLambertMaterial({color:0x141414});const rGeo=new THREE.CylinderGeometry(0.24,0.24,0.36,10);const rMat=new THREE.MeshLambertMaterial({color:0xbbbbbb});[[-1.02,1.42,true],[1.02,1.42,true],[-1.02,-1.42,false],[1.02,-1.42,false]].forEach(p=>{const sg=new THREE.Group();sg.position.set(p[0],0.44,p[1]);const spin=new THREE.Group();const t=new THREE.Mesh(wGeo,wMat);t.rotation.z=Math.PI/2;spin.add(t);const r=new THREE.Mesh(rGeo,rMat);r.rotation.z=Math.PI/2;spin.add(r);sg.add(spin);car.add(sg);wheels.push(spin);if(p[2])frontWheels.push(sg);});driverGroup=new THREE.Group();driverGroup.position.set(-0.45,0.62,-0.35);const dM=new THREE.MeshLambertMaterial({color:0xffffff});const sM=new THREE.MeshLambertMaterial({color:0xd9a06b});const shM=new THREE.MeshLambertMaterial({map:makeShmaghTexture()});const bd=new THREE.Mesh(new THREE.BoxGeometry(0.62,0.85,0.5),dM);bd.position.y=0.42;driverGroup.add(bd);const shr=new THREE.Mesh(new THREE.BoxGeometry(0.86,0.24,0.56),dM);shr.position.y=0.78;driverGroup.add(shr);const nk=new THREE.Mesh(new THREE.CylinderGeometry(0.1,0.11,0.16,8),sM);nk.position.y=0.95;driverGroup.add(nk);const hd2=new THREE.Mesh(new THREE.SphereGeometry(0.23,14,12),sM);hd2.position.y=1.17;driverGroup.add(hd2);const eM=new THREE.MeshBasicMaterial({color:0x1a1a1a});[-0.08,0.08].forEach(dx=>{const e=new THREE.Mesh(new THREE.SphereGeometry(0.028,6,6),eM);e.position.set(dx,1.20,0.21);driverGroup.add(e);});const ms=new THREE.Mesh(new THREE.BoxGeometry(0.16,0.035,0.04),new THREE.MeshLambertMaterial({color:0x2b1b0e}));ms.position.set(0,1.10,0.21);driverGroup.add(ms);const shT=new THREE.Mesh(new THREE.BoxGeometry(0.66,0.30,0.66),shM);shT.position.y=1.34;driverGroup.add(shT);const shB=new THREE.Mesh(new THREE.BoxGeometry(0.66,0.55,0.16),shM);shB.position.set(0,1.05,-0.28);driverGroup.add(shB);[-0.34,0.34].forEach(dx=>{const s=new THREE.Mesh(new THREE.BoxGeometry(0.15,0.5,0.6),shM);s.position.set(dx,1.08,0);driverGroup.add(s);});const ag=new THREE.Mesh(new THREE.TorusGeometry(0.30,0.045,8,18),new THREE.MeshLambertMaterial({color:0x111111}));ag.position.y=1.42;ag.rotation.x=Math.PI/2;driverGroup.add(ag);const aL=new THREE.Mesh(new THREE.BoxGeometry(0.15,0.15,0.6),dM);aL.position.set(-0.42,0.72,0.22);aL.rotation.x=-0.35;driverGroup.add(aL);const aR=new THREE.Mesh(new THREE.BoxGeometry(0.15,0.15,0.6),dM);aR.position.set(0.42,0.72,0.22);aR.rotation.x=-0.35;driverGroup.add(aR);car.add(driverGroup);const ws2=new THREE.Mesh(new THREE.TorusGeometry(0.2,0.035,8,16),new THREE.MeshLambertMaterial({color:0x1a1a1a}));ws2.position.set(-0.45,1.05,0.35);ws2.rotation.x=-0.5;car.add(ws2);const sMt=new THREE.MeshLambertMaterial({color:0x3a2a1a});[-0.45,0.45].forEach(dx=>{const s=new THREE.Mesh(new THREE.BoxGeometry(0.6,0.15,0.6),sMt);s.position.set(dx,0.6,-0.35);car.add(s);const bk=new THREE.Mesh(new THREE.BoxGeometry(0.6,0.6,0.14),sMt);bk.position.set(dx,0.9,-0.66);car.add(bk);});car.position.set(0,0,0);scene.add(car);}
const PHYS={maxSpeed:30,maxReverse:-9,accel:15,brakePower:26,friction:8,steerMax:0.55,turnRate:2.3};
function collides(x,z){const r=1.6;for(let i=0;i<obstacles.length;i++){const o=obstacles[i];if(x>o.minX-r&&x<o.maxX+r&&z>o.minZ-r&&z<o.maxZ+r)return true;}return false;}
function updateCar(dt){const p=PHYS;if(keys.f)carState.speed+=p.accel*dt;else if(keys.b)carState.speed-=p.brakePower*dt;else{if(carState.speed>0)carState.speed=Math.max(0,carState.speed-p.friction*dt);else if(carState.speed<0)carState.speed=Math.min(0,carState.speed+p.friction*dt);}carState.speed=Math.max(p.maxReverse,Math.min(p.maxSpeed,carState.speed));const si=(keys.l?1:0)-(keys.r?1:0);const ts=si*p.steerMax;carState.steer+=(ts-carState.steer)*Math.min(1,dt*9);const sf=Math.min(1,Math.abs(carState.speed)/5);const d=carState.speed>=0?1:-1;carState.angle+=carState.steer*sf*d*dt*p.turnRate;const nx=car.position.x+Math.sin(carState.angle)*carState.speed*dt;const nz=car.position.z+Math.cos(carState.angle)*carState.speed*dt;const lim=WORLD-12;let cx=Math.max(-lim,Math.min(lim,nx));let cz=Math.max(-lim,Math.min(lim,nz));if(collides(cx,cz)){carState.speed*=-0.22;if(Math.abs(carState.speed)<0.6)carState.speed=0;showDialogue('هيه! دير بالك! 🚧',1500);}else{car.position.x=cx;car.position.z=cz;}car.rotation.y=carState.angle;const sp=carState.speed*dt/0.44;wheels.forEach(w=>{w.rotation.x+=sp;});frontWheels.forEach(fw=>{fw.rotation.y=carState.steer*0.9;});car.rotation.z=-carState.steer*sf*0.05*d;if(Math.abs(carState.speed)>1){car.position.y=Math.sin(performance.now()*0.02)*0.012*Math.min(1,Math.abs(carState.speed)/10);}else{car.position.y=0;}}
const camTarget=new THREE.Vector3(),camDesired=new THREE.Vector3();
function updateCamera(dt){const ds=10+Math.abs(carState.speed)*0.14;const h=4.8;const fx=Math.sin(carState.angle);const fz=Math.cos(carState.angle);camDesired.set(car.position.x-fx*ds,car.position.y+h,car.position.z-fz*ds);const lp=1-Math.pow(0.0015,dt);camera.position.lerp(camDesired,lp);camTarget.set(car.position.x+fx*4,car.position.y+1.6,car.position.z+fz*4);camera.lookAt(camTarget);}
function showDialogue(t,d){const el=document.getElementById('dialogue');if(!el)return;el.textContent=t;el.classList.add('show');clearTimeout(dialogueTimer);dialogueTimer=setTimeout(()=>el.classList.remove('show'),d||3200);}
function updateHUD(){const k=Math.round(Math.abs(carState.speed)*3.6);const el=document.getElementById('speedVal');if(el)el.textContent=k;}
function setupControls(){window.addEventListener('keydown',e=>{switch(e.code){case'ArrowUp':case'KeyW':keys.f=true;e.preventDefault();break;case'ArrowDown':case'KeyS':keys.b=true;e.preventDefault();break;case'ArrowLeft':case'KeyA':keys.l=true;e.preventDefault();break;case'ArrowRight':case'KeyD':keys.r=true;e.preventDefault();break;case'KeyH':playHorn();break;case'KeyR':car.position.set(0,0,0);carState.speed=0;carState.angle=0;carState.steer=0;showDialogue('رجعت للمكان الأول 🔄',1800);break;}});window.addEventListener('keyup',e=>{switch(e.code){case'ArrowUp':case'KeyW':keys.f=false;break;case'ArrowDown':case'KeyS':keys.b=false;break;case'ArrowLeft':case'KeyA':keys.l=false;break;case'ArrowRight':case'KeyD':keys.r=false;break;}});function bind(id,on,off){const el=document.getElementById(id);if(!el)return;const s=e=>{e.preventDefault();el.classList.add('press');on();};const en=e=>{e.preventDefault();el.classList.remove('press');off();};el.addEventListener('pointerdown',s);el.addEventListener('pointerup',en);el.addEventListener('pointerleave',en);el.addEventListener('pointercancel',en);el.addEventListener('contextmenu',e=>e.preventDefault());}bind('btnLeft',()=>keys.l=true,()=>keys.l=false);bind('btnRight',()=>keys.r=true,()=>keys.r=false);bind('btnGas',()=>keys.f=true,()=>keys.f=false);bind('btnBrake',()=>keys.b=true,()=>keys.b=false);const hb=document.getElementById('hornBtn');if(hb)hb.addEventListener('pointerdown',e=>{e.preventDefault();playHorn();});if('ontouchstart'in window||navigator.maxTouchPoints>0){document.getElementById('touch').classList.add('on');}window.addEventListener('resize',onResize);window.addEventListener('orientationchange',()=>setTimeout(onResize,250));}
function onResize(){if(!camera||!renderer)return;camera.aspect=window.innerWidth/window.innerHeight;camera.updateProjectionMatrix();renderer.setSize(window.innerWidth,window.innerHeight);renderer.setPixelRatio(Math.min(window.devicePixelRatio,2));}
function init(){scene=new THREE.Scene();scene.fog=new THREE.Fog(0xdfd0ac,130,420);camera=new THREE.PerspectiveCamera(62,window.innerWidth/window.innerHeight,0.1,1400);camera.position.set(0,6,-12);renderer=new THREE.WebGLRenderer({antialias:true,powerPreference:'high-performance'});renderer.setPixelRatio(Math.min(window.devicePixelRatio,2));renderer.setSize(window.innerWidth,window.innerHeight);renderer.shadowMap.enabled=false;document.getElementById('game').appendChild(renderer.domElement);scene.add(new THREE.HemisphereLight(0xffffff,0xc9b184,0.95));const sl=new THREE.DirectionalLight(0xffe9b8,1.15);sl.position.set(90,140,60);scene.add(sl);const fl=new THREE.DirectionalLight(0xaaccee,0.35);fl.position.set(-80,60,-70);scene.add(fl);clock=new THREE.Clock();buildSky();buildGround();buildRoads();buildCity();buildCar();setupControls();const ld=document.getElementById('loader');if(ld){ld.style.transition='opacity .5s';ld.style.opacity='0';setTimeout(()=>ld.remove(),550);}animate();}
function animate(){requestAnimationFrame(animate);const dt=Math.min(clock.getDelta(),0.05);if(gameStarted){updateCar(dt);updateEngineSound();updateHUD();quoteTimer+=dt;if(quoteTimer>nextQuoteIn){quoteTimer=0;nextQuoteIn=9+Math.random()*9;const q=IRAQI_QUOTES[Math.floor(Math.random()*IRAQI_QUOTES.length)];showDialogue(q,3200);}}updateCamera(dt);renderer.render(scene,camera);}
document.getElementById('startBtn').addEventListener('click',function(){const m=document.getElementById('menu');m.classList.add('hide');setTimeout(()=>m.style.display='none',750);document.getElementById('hud').classList.add('on');if('ontouchstart'in window||navigator.maxTouchPoints>0){document.getElementById('touch').classList.add('on');}initAudio();if(audioCtx&&audioCtx.state==='suspended')audioCtx.resume();gameStarted=true;setTimeout(()=>{showDialogue('يلا ننطلق! أنا علاوي، راح أوريك شوارع العراق 🇮🇶🚗',4200);},900);});
window.addEventListener('load',()=>{try{init();}catch(err){console.error(err);const ld=document.getElementById('loader');if(ld)ld.innerHTML='<div style="color:#ff6b6b;text-align:center;padding:20px;font-family:Tahoma">حدث خطأ بالتحميل<br><small style="color:#aaa">'+err.message+'</small></div>';}});
</script>
</body>
</html>
''';