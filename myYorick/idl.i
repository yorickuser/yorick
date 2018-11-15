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
idl_rotation=0;
idl_rotation_speed=array(0.0,3);
idl_ro_axis=0;
idl_old_lim=[0,1,0,1,15];

idl_but_labs_n=7;
idl_but_labs_pvx=3.0;
idl_but_labs_pvy=array(0.0,idl_but_labs_n+1);
idl_but_labs=array("",idl_but_labs_n);



func axis_rot3_ho(ddx,ddy,&ro_axis,&dro){
  local xx,yy,z;
                xyz=[[-1.,-1.,-1.],[1.,-1.,-1.],[-1.,1.,-1.],[-1.,-1.,1.]];
                get3_xy, xyz, xx, yy, z, 1;
                xbuf=xx;ybuf=yy;
                xx-=xx(1);yy-=yy(1);
                xx=xx(2:);yy=yy(2:);
                rr=abs(xx,yy);
                xx=xx/rr;yy=yy/rr;
                
               
                ro_axis=abs(xx*ddx +yy*ddy)(mnx);
                dro=-2*(xx*ddy -yy*ddx)(ro_axis);
            
}


func idl_fun3(void){
 command=rdline(,1,prompt="Enter command: ")
 exec,command;
}


func check_but(void,oldlim=){
  extern idl_but_labs_n;
 
  check2=0;
  curm=current_mouse();
  dlim=limits();
  if(is_void(oldlim))oldlim=dlim;

  if(numberof(curm)>0){
    mmx=curm(1)/(oldlim(2));
    mmy=(curm(2)-oldlim(3))/(oldlim(4)-oldlim(3));
    
    
  if(mmx>0.99){
    
     
      for(i=1;i<=idl_but_labs_n;i++){
        mmy_hi=1.0-1.0*(i-1)/(idl_but_labs_n);
        mmy_lo=1.0-1.0*i/(idl_but_labs_n);
        if((mmy>mmy_lo)*(mmy<mmy_hi)){
          //          write,i,mmy_lo,mmy,mmy_hi;
          check2=i;
        }
      }
  }
  }

 
    return check2;
}
          
func print_but(lab,col,id,col0=){
  extern idl_but_labs,idl_but_labs_n,idl_but_labs_pvx,idl_but_labs_pvy;

  pvx=idl_but_labs_pvx;
  pvy=idl_but_labs_pvy;
  
  if(is_void(col0))col0=black;
  plt," ********",pvx,pvy(id),color=col0,justify="LC";
  
  
  plt,idl_but_labs(id),pvx,0.5*(pvy(id)+pvy(id+1)),color="bg",justify="LC";
  idl_but_labs(id)=lab;
  plt,idl_but_labs(id),pvx,0.5*(pvy(id)+pvy(id+1)),color=col,justify="LC";
  
  plt," ********",pvx,pvy(id+1),color=col0,justify="LC";
}

func idl_zoom(amp,li){
     
                            
  flag_sidex=((li(2)-x(1))>0.99*(li(2)-li(1)))+((x(1)-li(1))>0.99*(li(2)-li(1)));
  flag_sidey=((li(4)-x(2))>0.99*(li(4)-li(3)))+((x(2)-li(3))>0.99*(li(4)-li(3)));
  
  ampx=amp;
  ampy=amp;
  if(flag_sidex)ampx=1;
  if(flag_sidey)ampy=1;
  
  limits, x(1)-ampx*(x(1)-li(1)),x(1)+ampx*(li(2)-x(1)),x(2)-ampy*(x(2)-li(3)),x(2)+ampy*(li(4)-x(2));
}


idl_pal_id=-1;
func change_pal(void){
  pals=["heat","sunrise","bb","rr","gg","koge","rg2","wine"];
  idl_pal_id+=1;
  idl_pal_id= idl_pal_id%(numberof(pals));
  pal,pals(idl_pal_id+1);
  write,"Palette changed to:",pals((idl_pal_id+1));
}

func switch_ro_axis(void){
  extern idl_ro_axis;
  idl_ro_axis=(idl_ro_axis+1)%2;
  if(idl_ro_axis==0){write,"Rotation along axis: On";}
  if(idl_ro_axis==1){write,"Rotation along axis: Off";}
}


func idl(dp,count,rot=,stop=,fun1=,fun2=,fun3=,rot_hist=)
/* DOCUMENT if(idl(dp))break;
   DEFINITION idl(dp,count,rot=,stop=,fun1=,fun3=)

 Idling function for event driven programing controlled by mouse click.
 This function uses "limits()" function to detect the state of mouse.

The labels on the right side of window can be pushed by Mouse-Right-button.

DP is waiting time at each execution of this function.
If COUNT is given, the value is printed at each "stop" event.
IF ROT is 1, 3D-rotation is enabled.


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
  extern idl_fun3;
  extern idl_rotation, idl_rotation_speed,idl_ro_axis,idl_old_lim;
  extern idl_initial_pause, idl_but_labs,idl_but_labs_n,idl_but_labs_pvx,idl_but_labs_pvy;
  
  local xx,yy,z,ro_axis,dro;


  ro_amp=0.1;
  edge_ddr=0.00001;
  
  
  
  if(is_void(rot_hist))rot_hist=0;
  if(is_void(dp))dp=1;
  if(is_void(rot))rot=0;
  if(is_void(fun3))fun3=idl_fun3;
  change_lim=0;
  flag_stop=0;

   pv=viewport();
    //plsys,0;
   idl_but_labs_pvx=pv(2);
   idl_but_labs_pvy=span(pv(4),pv(3),(idl_but_labs_n+1));
   
    //  plg,pvy,pvx,width=4,closed=1;
    //plsys,1;
    
      print_but," Pause","blue",1,col0="black";
      print_but," End","blue",2,col0="black";
      print_but," Command","blue",3,col0="black";
      print_but," Palette","blue",4,col0="black";
      print_but,(" Rot:"+swrite(format="%d",idl_ro_axis)),"blue",5,col0="black";
      print_but," Fun1","blue",6,col0="black";
      print_but," Fun2","blue",7,col0="black";
   
  if(idl_initial_pause==1){
    flag_stop=1;
    idl_initial_pause=0;

    idl_old_lim=limits();
 

    write,"Press labels on the right side of window with Mouse-Right-Button.";
    write,"";
    write,"Alternative mouse control is as follows:";
    write,"";
    write,"Ctrl + Right-button to Start/Pause";
    write,"[Shift-key + Right-button] twice to End (during Pause)";
    write,"(Right: Mouse Right Button,  Left: Mouse Left Button)";

    write,"";
    if(rot==1){
      write,"<During Pause>";
      write,"Rotate: Ctrl + Left drag";
      write,"Zoom in/out: Left/Right";
      write,"Move: Shift + Left drag";
      write,"Enter command: Shift + Right, and Ctrl + Right";
      write,"Switch rotation mode: Shift + Right, and Right";
    }
    if(rot==0){
      write,"<During Pause>";
      write,"Zoom in/out: Lefr/Right";
      write,"Move: Shift + Left drag";
      write,"Enter command: Shift + Right, and Ctrl +Right";
      write,"Execute fun1(if specified): Ctrl + Left";
    }
        write,"";
    
  }

   
  redraw;
  
  //  oldlim=limits();
  
  pause,dp;
  oldlim=idl_old_lim;
  newlim=limits();
  
  //if((newlim(2)-newlim(1))>1.2*(oldlim(2)-oldlim(1))){

  check1=((newlim(2)-newlim(1))*4< (oldlim(2)-oldlim(1)));
   
  check2=check_but(oldlim=oldlim);
 
  push_side=((newlim(4)-newlim(3))>1.2*(oldlim(4)-oldlim(3)));
  
  push_but=check2*push_side;

  if(push_but>1){
    if(push_but==2){write,"End";return 1;}
    if(push_but==3){fun3;}
    if(push_but==4){change_pal;}
    if(push_but==5){switch_ro_axis;}
    if(push_but==6){if(!is_void(fun1))fun1;}
    if(push_but==7){if(!is_void(fun2))fun2;}
    limits,oldlim;
  }
  if(check1+(push_but==1)){
    flag_stop=(flag_stop+1)%2;
    limits,oldlim;
    check2;
  }
  
  if(flag_stop){
   
   
      if((!is_void(count)))write,"Stop:",count;
      else write,"Stop";
   
    animate,0;

     
  }

  if(rot==1){
    if(idl_rotation==1)rot3,idl_rotation_speed(1),idl_rotation_speed(2);
    if(idl_rotation==2)rot3_ho,idl_rotation_speed(1),idl_rotation_speed(2),idl_rotation_speed(3);
  }


  
  while(flag_stop==1){
   
    
   redraw;
   pause,10;
   print_but," Start","red",1,col0="black";
   print_but," End","blue",2,col0="black";
   print_but," Command","blue",3,col0="black";
   print_but," Palette","blue",4,col0="black";
   print_but," Rot:"+swrite(format="%d",idl_ro_axis),"blue",5,col0="black";
   print_but," Fun1","blue",6,col0="black";
   print_but," Fun2","blue",7,col0="black";
   redraw;
      li=limits();
      x= mouse(1, 2,"");
      //x= mouse(1, 1,"");
    
      
      ddy=((x(4)-x(2))/(li(4)-li(3)));
      ddx=((x(3)-x(1))/(li(2)-li(1)));
      ddr=sqrt(ddx^2+ddy^2);

      
      if(x(10)==3){
          //idl_rotation=0;
          //animate,0;
          if(x(11)==0){
            check2=check_but()
              check2;
           
              if(check2>0){

                if(check2==7){if(!is_void(fun2))fun2;}
                if(check2==6){if(!is_void(fun1))fun1;}
                if(check2==5){switch_ro_axis;}
                
                if(check2==4){change_pal;}
                if(check2==3){fun3;}
                if(check2==2){
                  write,"End";return 1;
                }
                if(check2==1){
                  
                  flag_stop=0;
                  //write,"Start";
                  animate,1;
                  write,"Start";
                }
              }else{
                amp=1.3;
                idl_zoom,amp,li;
                       
              }
          }
          if(x(11)==4){
            flag_stop=0;
            //write,"Start";
            animate,1;
            write,"Start";
            if(rot==1){
              if(ddr>edge_ddr){
                if(idl_ro_axis==0){
                  idl_rotation=1;
                  idl_rotation_speed(1:2)=[-1*ddy,ddx]*ro_amp;
                }
                if(idl_ro_axis==1){
                  idl_rotation=2;            
                  axis_rot3_ho,ddx,ddy,ro_axis,dro;
                  //ro_axis;
                  //dro;
                  idl_rotation_speed*=0.0;
                  idl_rotation_speed(ro_axis)=dro*ro_amp;
                  //idl_rotation_speed;
                }
                         
              }else{

                if(rot_hist==0)idl_rotation=0;
             
              //idl_rotation_speed*=0;
            }
            }
            
          }    
          if(x(11)==1){
           
            xb=mouse(1, 2,"[ctrl+right]: enter command\n[right]: switch rotation mode\n[shift+right]: end \n choice: ");
            if((xb(10)==3)*(xb(11)==4)){
              "fun3";
              fun3;
            }
            if((xb(10)==3)*(xb(11)==0)){
              if(idl_ro_axis==0){idl_ro_axis=1;write,"Rotation along axis: On";}
              else{idl_ro_axis=0;write,"Rotation along axis: Off";}
            }
            if((xb(10)==3)*(xb(11)==1)){
              write,"End";return 1;
            }
          }
        }
      
      

      if(x(10)==2){
        
        if(ddr<edge_ddr){
      
          limits;
                
        }else{
          limits,li(1)+(x(1)-x(3)),li(2)+(x(1)-x(3)),li(3)+(x(2)-x(4)),li(4)+(x(2)-x(4));
         
        }
       }

      
      if(x(10)==1){

          if(x(11)==0){

          
          if(ddr<edge_ddr){
          
            amp=1.0/1.3;
            idl_zoom,amp,li;
          }else{
            amp = exp(-2.0*ddy);
            amp_pow=2*abs(ddy)/ddr;
            amp=amp^amp_pow;
            limits, x(1)-amp*(x(1)-li(1)),x(1)+amp*(li(2)-x(1)),x(2)-amp*(x(2)-li(3)),x(2)+amp*(li(4)-x(2));
          }
          
         
          }
        
       
          if(x(11)==4){
            if(ddr<edge_ddr){
              //   "fun1";
              //if(!is_void(fun1))fun1;
              //limits;
              scale,0.9;
            }
          }
        

        if(rot==1){
          if(x(11)==4){
          
        
            if(idl_ro_axis==0){
              rot3,-4*ddy,4*ddx;
            }else{
              
                
              axis_rot3_ho,ddx,ddy,ro_axis,dro;
              
              if(ro_axis==3)rot3_ho,,,dro;
              if(ro_axis==1)rot3_ho,dro,,;
              if(ro_axis==2)rot3_ho,,dro,;
                
              
            }
          }
          draw3,1;
        }
          
         
      }
  }
  idl_old_lim=newlim;
}


func ro1(void){
  extern idl_initial_pause,idl_rotation_speed,idl_rotation,idl_ro_axis;
  idl_initial_pause=1;
  idl_rotation=2;
  idl_rotation_speed=[0,0,0.01];
  idl_ro_axis=1;
  idl_
  // t=0;
  // animate,1;
  while(1){
    //       current_mouse(0);
    //focused_window();
    //has_mouse(0);
    //    pl3surf,nv,xyzv;
    draw3_trigger;
    //rot3,0,0;
    draw3,1;
    //t+=1;
    if(idl(0,rot=1,rot_hist=1))break;
  }
  animate,0;  
}



//ro1;

