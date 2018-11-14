/*
  IDL.I
  functions for event-driven programing, written by Hiroshi C. Ito. 2018
  
 */

/* functions in this file. (type "help, function_name" at yorick prompt for examples)

idl: idling function for event driven programing controlled by mouse click.
*/


require, Y_DIR+"graph2d.i";
require, Y_DIR+"graph3d.i";

idl_initial_pause=0;

func idl_fun2(void){
 command=rdline(,1,prompt="Enter command: ")
 exec,command;
}


func idl(dp,count,rot=,stop=,fun1=,fun2=)
/* DOCUMENT if(idl(dp))break;
   DEFINITION idl(dp,count,rot=,stop=,fun1=,fun2=)

 Idling function for event driven programing controlled by mouse click.
 This function uses "limits()" function to detect the state of mouse.
 
DP is waiting time at each execution of this function.
If COUNT is given, the value is printed at each "stop" event.
IF ROT is 1, 3D-rotation is enabled.

<Under running mode>
Right button: pause/restart simulation

<Under pause mode>
Right button with Shift-key : halt the simulation
Middle button (or Left button with Shift-key): move the object
Left button with Ctrl-key: Dragging up/down is zoom/pan.

Left button (when ROT is 1): Dragging rotates ploted object.
Left button (when ROT is 0): call function "fun1" if exists.

Right button with Ctrl-key (when ROT is 1): switch whether rotation is along either axis or not.
Right button with Ctrl-key (when ROT is 1): call function "fun2" if specified as an argumet of idl. If not specified, a default function "idl_fun2" is called, and you can enter any comannd, e.g., "outpng","scale,0.8", "limits", "extern n; n=5;". If a variable is decleared globally, its value can easily be changed by "extern variable_name; variable_name = new_value;".

SEE ALSO: mouse, pause
<Example>
Each of following examples is execuded by
include,"idl_demo0.i";
include,"idl_demo1.i";
include,"idl_demo2.i";
include,"idl_demo3.i";

<Example 0  "idl_demo0.i">

line_color=red;
idl_initial_pause=1;
x=span(0,12,100);
win2;
animate,1;
for(i=0;i<=10000;i++){
fma;
plg,sin(i*0.05+x)+cos(-i*0.08+1.5*x+1),x,color=line_color;
if(idl(20))break;
}
animate,0;

<Example 1  "idl_demo1.i">

//function1 is called by [left button]: changes palette
func function1(void){
  cpal=["earth","heat","sunrise","bb"];
  id=1;
  n=read(prompt="Choose palette: 1: earth, 2: heat, 3: sunrise, 4: bb >",id);
  pal,cpal(id);
}

nlevs=10;

func idl_demo1(dp){
if(is_void(dp))dp=20;
extern nlevs;
x= span(-3,3,64)(,-:1:64);
y= transpose(x);
  z= sin(2*sqrt(x^2+y^2))+cos(x+y+0.13);
  
  animate,1;
  
  for(t=0;t<=10000;t++){
    z= sin(2*sqrt(x^2+y^2)+0.02*t)+cos(x+y+0.013*t);
    fma;
    levs=span(-1.5,1.5,nlevs);
    plfc,z,y,x,levs=levs;
    plc,z,y,x,color=red,levs=levs;
    cbfc,[-2,2],levs=levs,ticks=1,label=1;
    redraw;
    if(idl(dp,fun1=function1))break;
  }
  animate,0;
}

idl_initial_pause=1;
win2;
idl_demo1,10;


<Example 2  "idl_demo2.i">

func idl_demo2(void){
  x= span(-3,3,32)(,-:1:32);
  y= transpose(x);
  z= sin(2*sqrt(x^2+y^2))+cos(x+y+0.13);
  make_xyz,z,y,x,nv,xyzv;

  pl3surf,nv,xyzv;
  lim3,3,3,6;
  cage3,1;
  orient3;
  setz3,7;
  limits;
  draw3,1;
  scale,0.9;
   
  animate,1;
  for(t=0;t<=1000;t++){
    xyzv(3,)= sin(2*sqrt(xyzv(1,)^2+xyzv(2,)^2)+0.2*t)+cos(xyzv(1,)+xyzv(2,)+0.13*t);
    
    pl3surf,nv,xyzv;
    lim3,3,3,6;
    draw3,1;
    if(idl(20,t,rot=1))break;
  }
  animate,0;
}

idl_initial_pause=1;
win2;
win3;
idl_demo2;

<Example 3  "idl_demo3.i">

func function1(void){
  cpal=["earth","heat","sunrise","bb","cr"];
  id=1;
  n=read(prompt="Choose palette: 1: earth, 2: heat, 3: sunrise, 4: bb, 5: cr >",id);
  pal,cpal(id);
}

size = 120;
dt =0.2;
view_interval=100;
count_interval=1000;
a = 0.023;
b = 0.055;

gridx=span(0,1,size)(,-:1:size);
gridy=transpose(gridx);
dif_gridx=span(0.3,2.0,size)(,-:1:size);
dif_gridy=transpose(dif_gridx);
dif_rate_x = (8.0e-2)*dif_gridx;
dif_rate_y = (4.6e-2)*dif_gridy;

x=array(1.0,size,size);
y=array(0.001,size,size);
y(size/2,size/3) = 0.5;
diffuse_mask=grow(1,indgen(size),size);

func idl_demo3 (T,dp=){
  if(is_void(T))T=10000;
  if(is_void(dp))dp=1;
  fma;
  plfc,y,gridy,gridx,levs=spanl(0.05,0.6,20);
  xyt,"Diffusion rate for x", "Diffusion rate for y";
  limits;
  
  animate,1;
  for(t=0; t<=T;t++){
    diffuse_x=(x(,diffuse_mask)(,dif)(,dif)+x(diffuse_mask,)(dif,)(dif,));
    diffuse_y=(y(,diffuse_mask)(,dif)(,dif)+y(diffuse_mask,)(dif,)(dif,));
    x += dt*(-1.0*x*y*y + a*(1.0-x) +dif_rate_x*diffuse_x);
    y += dt*(x*y*y - (a+b)*y+dif_rate_y*diffuse_y);
    
    if(t%count_interval==0)t; 
    if(t%view_interval==0){
      fma;
      plfc,y,gridy,gridx,levs=spanl(0.05,0.6,20);
      xyt,"Diffusion rate for x", "Diffusion rate for y";
  
  
      if(idl(5,fun1=function1))break;
    }
    
  }
  animate,0;
}

idl_initial_pause=1;
win2;
idl_demo3,50000;


*/
{
  extern idl_fun2;
  extern idl_initial_pause;
  redraw;
  
  flag_ro_axis=0;
  if(is_void(dp))dp=1;
  if(is_void(rot))rot=0;
  if(is_void(fun2))fun2=idl_fun2;
  change_lim=0;
  flag_stop=0;
  if(idl_initial_pause==1){
    flag_stop=1;
    idl_initial_pause=0;

    
    write,"";
    write,"Right-button to Start/Pause";
    write,"Shift-key + Right-button to End (during Pause)";
    write,"(Right: Mouse Right Button,  Left: Mouse Left Button)";

    write,"";
    if(rot==1){
      write,"<During Pause>";
      write,"Rotate: Left drag";
      write,"Zoom/Pan: Ctrl + Left drag (up/down)";
      write,"Move: Shift + Left drag";
      write,"Enter command: Ctrl + Right, and tCtrl + Right";
      write,"Switch rotation mode: Ctrl + Right, and Right";
    }
    if(rot==0){
      write,"<During Pause>";
      write,"Zoom/Pan: Ctrl + Left drag (up/down)";
      write,"Move: Shift + Left drag";
      write,"Enter command: Ctrl + Right";
      write,"Execute fun1(if specified): Left";
    }
        write,"";
    
  }
  oldlim=limits();  
  pause,dp;
  newlim=limits();
  
  if((newlim(2)-newlim(1))>1.2*(oldlim(2)-oldlim(1))){
      flag_stop=(flag_stop+1)%2;
      limits,oldlim;
  }
  
  if(flag_stop){
      if((!is_void(count)))write,"Stop:",count;
      else write,"Stop";
      animate,0;
  }
  while(flag_stop==1){
    
    pause,10;
      li=limits();
      x= mouse(1, 2,"");
      //x= mouse(1, 1,"");
      
      if(x(10)==3){
        if(x(11)==1){write,"End";return 1;}
        if(x(11)==0){flag_stop=0;animate,1;}    
        if(x(11)==4){
          if(rot==0){
            "fun2";
            if(!is_void(fun2)){              
              fun2;
              draw3,1;
            }
          }else{
            xx=mouse(1, 2,"[ctrl+right]: enter command\n[right]: switch rotation mode \n choice: ");
            if((xx(10)==3)*(xx(11)==4)){
              fun2;
            }
            if((xx(10)==3)*(xx(11)==0)){
            if(flag_ro_axis==0){flag_ro_axis=1;write,"Rotation along axis: On";}
            else{flag_ro_axis=0;write,"Rotation along axis: Off";}
            }
          }
        }
          
      }

      if(x(10)==2){
            
            limits,li(1)+(x(1)-x(3)),li(2)+(x(1)-x(3)),li(3)+(x(2)-x(4)),li(4)+(x(2)-x(4));
       }
      if(x(10)==1){
        //x(10:11);
        //    ro_axis; 
              if(x(11)==4){
                amp = exp(2.0*(x(2)-x(4))/(li(4)-li(3)));
                amp_pow=2*sqrt((x(4)-x(2))^2/((x(4)-x(2))^2+(x(3)-x(1))^2));
                amp=amp^amp_pow;
                limits, x(1)-amp*(x(1)-li(1)),x(1)+amp*(li(2)-x(1)),x(2)-amp*(x(2)-li(3)),x(2)+amp*(li(4)-x(2));
            }
              if((rot==0)*(x(11)==0)){
                "fun1";
                if(!is_void(fun1))fun1;
              }else{
                if(x(11)==0){
              if(flag_ro_axis==0){
                rox = (x(2)-x(4))/(li(4)-li(3));
                roy = (x(3)-x(1))/(li(2)-li(1));
                rot3,4*rox,4*roy;
              }else{
                xyz=[[-1.,-1.,-1.],[1.,-1.,-1.],[-1.,1.,-1.],[-1.,-1.,1.]];
                get3_xy, xyz, xx, yy, z, 1;
                xbuf=xx;ybuf=yy;
                xx-=xx(1);yy-=yy(1);
                xx=xx(2:);yy=yy(2:);
                rr=abs(xx,yy);
                xx=xx/rr;yy=yy/rr;
                roy=(x(4)-x(2))/(li(4)-li(3));
                rox=(x(3)-x(1))/(li(2)-li(1));
                
                ro_axis=abs(xx*rox +yy*roy)(mnx);
                dro=-2*(xx*roy -yy*rox)(ro_axis);
                
                
                if(ro_axis==3)rot3_ho,,,dro;
                if(ro_axis==1)rot3_ho,dro,,;
                if(ro_axis==2)rot3_ho,,dro,;
                
              
              }
            
                }
          
          
              }
          
              if(rot==1)draw3,1;
      }
  }
}

