/*
  IDL.I
  functions for event-driven programing, written by Hiroshi C. Ito. 2018
  
 */

/* functions in this file. (type "help, function_name" at yorick prompt for examples)

idl: idling function for event driven programing controlled by mouse click.
*/


require, Y_DIR+"graph2d.i";
require, Y_DIR+"graph3d.i";

idl_default_button="BOTH";
//idl_default_button="RIGHT";
//idl_default_button="LEFT";
idl_initial_pause=0;
idl_rotation=0;
idl_rotation_speed=array(0.0,3);
idl_ro_axis=0;
idl_old_lim=[0,1,0,1,15];

idl_but_labs_n=8;
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
  if(col0!="")plt," ********",pvx,pvy(id),color=col0,justify="LH";
  
  
  plt,idl_but_labs(id),pvx,0.5*(pvy(id)+pvy(id+1)),color="bg",justify="LH";
  idl_but_labs(id)=lab;
  plt,idl_but_labs(id),pvx,0.5*(pvy(id)+pvy(id+1)),color=col,justify="LH";
  
  if(col0!="")plt," ********",pvx,pvy(id+1),color=col0,justify="LH";
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
 
pals=["earth","heat","sunrise","cr","sun","bb","rr","gg","cool","gray","br","by","blue","koge","wine","te","yb","silver","earth2","gray2","cale","rg2","gr2","bg2","bb_rev","purple"];
idl_pal_id=0;
func change_pal(add_id){
  extern idl_pal_id,pals;
  
  idl_pal_id= (idl_pal_id-1+sign(add_id))%(numberof(pals)) +1;
  if(idl_pal_id==0)idl_pal_id=numberof(pals);
  pal,pals(idl_pal_id);

  write,"Palette changed to:",pals((idl_pal_id));
}

func set_pal(id){
  extern idl_pal_id,pals;
  idl_pal_id=id;
  pal,pals(idl_pal_id);

  write,"Palette set to:",pals((idl_pal_id));
}

func switch_ro_axis(void){
  extern idl_ro_axis;
  idl_ro_axis=(idl_ro_axis+1)%2;
  if(idl_ro_axis==0){write,"Rotation along axis: OFF";}
  if(idl_ro_axis==1){write,"Rotation along axis: ON";}
}

func print_mouse_use(void){
    write,"Press labels on the right side of window with Mouse-Right/Left-Button.";
    write,"3D-plottings can be rotated by Ctrl+Mouse-Right/Left-Button drag.";
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


   
   func  get_push_name(x,ddr,edge_ddr){
     bu="";
     if(x(10)==1)bu="1_";
     if(x(10)==2)bu="2_";
     if(x(10)==3)bu="3_";
     if(x(11)==1)bu+="Shift_";
     if(x(11)==4)bu+="Ctrl_";
     if(ddr<edge_ddr)bu+="click";
     if(ddr>=edge_ddr)bu+="drag";
     return bu;
   }

func idl_set_rotation(x,li,ro_amp){
  extern idl_ro_axis,idl_rotation, idl_rotation_speed;
    ddy=((x(4)-x(2))/(li(4)-li(3)));
  ddx=((x(3)-x(1))/(li(2)-li(1)));
  ddr=sqrt(ddx^2+ddy^2);

  if(idl_ro_axis==0){
    idl_rotation=1;
    idl_rotation_speed(1:2)=[-1*ddy,ddx]*ro_amp;
  }
  if(idl_ro_axis==1){
    idl_rotation=2;            
    axis_rot3_ho,ddx,ddy,ro_axis,dro;
    
    idl_rotation_speed*=0.0;
    idl_rotation_speed(ro_axis)=dro*ro_amp;
    
  }
}


func idl_rot3(x,li){
  extern idl_ro_axis;

    ddy=((x(4)-x(2))/(li(4)-li(3)));
  ddx=((x(3)-x(1))/(li(2)-li(1)));
  ddr=sqrt(ddx^2+ddy^2);

  if(idl_ro_axis==0){
    rot3,-4*ddy,4*ddx;
  }else{
    
    
    axis_rot3_ho,ddx,ddy,ro_axis,dro;
    
    if(ro_axis==3)rot3_ho,,,dro;
    if(ro_axis==1)rot3_ho,dro,,;
    if(ro_axis==2)rot3_ho,,dro,;         
    
  }
}

func idl_zoom_smooth(x,li){
  ddy=((x(4)-x(2))/(li(4)-li(3)));
  ddx=((x(3)-x(1))/(li(2)-li(1)));
  ddr=sqrt(ddx^2+ddy^2);
  
  amp = exp(-2.0*ddy);
  amp_pow=2*abs(ddy)/ddr;
  amp=amp^amp_pow;
       limits, x(1)-amp*(x(1)-li(1)),x(1)+amp*(li(2)-x(1)),x(2)-amp*(x(2)-li(3)),x(2)+amp*(li(4)-x(2));
}

func idl_move(x,li){
       limits,li(1)+(x(1)-x(3)),li(2)+(x(1)-x(3)),li(3)+(x(2)-x(4)),li(4)+(x(2)-x(4));
}


func idl(dp,count,rot=,stop=,fun1=,fun2=,fun3=,rot_hist=)
/* DOCUMENT if(idl(dp))break;
   DEFINITION idl(dp,count,rot=,stop=,fun1=,fun3=)

 Idling function for event driven programing controlled by mouse click.
 This function uses "limits()" function to detect the state of mouse.

The labels on the right side of window can be pushed by Mouse-Right/Light-button.

DP is waiting time at each execution of this function.
If COUNT is given, the value is printed at each "stop" event.
IF ROT is 1, 3D-rotation is enabled.

<Examples>
include,"idl_demo0.i";
include,"idl_demo1.i";
include,"idl_demo2.i";
include,"idl_demo3.i";


SEE ALSO: mouse, pause

*/
{
  extern idl_fun3;
  extern idl_rotation, idl_rotation_speed,idl_ro_axis,idl_old_lim;
  extern idl_initial_pause, idl_but_labs,idl_but_labs_n,idl_but_labs_pvx,idl_but_labs_pvy,idl_default_button;
  
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
   
 
   print_but," End","blue",2,col0="black";
   print_but," Palette: "+swrite(format="%d\n \"%s\"",idl_pal_id,pals(idl_pal_id)),"blue",3,col0="black";

   print_but," Command","blue",4,col0="black";
   
   print_but,(" Rot:"+swrite(format="%d",idl_ro_axis)),"blue",5,col0="black";
   print_but," Fun1","blue",6,col0="black";
   print_but," Fun2","blue",7,col0="black";
   print_but," Reset","blue",8,col0="black";

     print_but," Pause","blue",1,col0="black";
     
  if(idl_initial_pause==1){
    flag_stop=1;
    idl_initial_pause=0;
    set_pal,1;
    idl_old_lim=limits();
    print_mouse_use;
  }
   
  redraw;
  
   
  pause,dp;
  oldlim=idl_old_lim;
  newlim=limits();
  
  //if((newlim(2)-newlim(1))>1.2*(oldlim(2)-oldlim(1))){

  check1=((newlim(2)-newlim(1))*4< (oldlim(2)-oldlim(1)));
   
  check2=check_but(oldlim=oldlim);


  push_but_R=check2*((newlim(4)-newlim(3))>1.2*(oldlim(4)-oldlim(3)));
  push_but_L=check2*((newlim(4)-newlim(3))<(1.0/1.2)*(oldlim(4)-oldlim(3)));
  
  if(push_but_L+push_but_R >0){
  
    
    if(idl_default_button=="RIGHT")push_but=push_but_R;
    if(idl_default_button=="LEFT")push_but=push_but_L;
    if(idl_default_button=="BOTH")push_but=push_but_L+push_but_R;
    
    if(push_but==2){write,"End";return 1;}
         
    if(push_but_R==3)change_pal,1;
    if(push_but_L==3)change_pal,-1;
 
    if(push_but==4){fun3;}
    
    if(push_but==5){switch_ro_axis;}
    if(push_but==6){"fun1";if(!is_void(fun1))fun1;}
    if(push_but==7){"fun2";if(!is_void(fun2))fun2;}
    if(push_but==8){limits;{if(rot==1)scale,0.9;};oldlim=limits();}
  
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
   
   

   print_but," End","blue",2,col0="black";
    print_but," Palette: "+swrite(format="%d\n \"%s\"",idl_pal_id,pals(idl_pal_id)),"blue",3,col0="black";
   print_but," Command","blue",4,col0="black";
   

   print_but," Rot:"+swrite(format="%d",idl_ro_axis),"blue",5,col0="black";
   print_but," Fun1","blue",6,col0="black";
   print_but," Fun2","blue",7,col0="black";
   print_but," Reset","blue",8,col0="black";

   print_but," Start","red",1,col0="red";
      
   redraw;
   li=limits();
   
   x= mouse(1, 2,"");
      //x= mouse(1, 1,"");
    

   ddy=((x(4)-x(2))/(li(4)-li(3)));
   ddx=((x(3)-x(1))/(li(2)-li(1)));
   ddr=sqrt(ddx^2+ddy^2);

   bu=get_push_name(x,ddr,edge_ddr);
     bu;
     button_id=check_but();
     push_but_R=button_id*((bu=="3_click")+(bu=="3_drag"));
     push_but_L=button_id*((bu=="1_click")+(bu=="1_drag"));
     
     if(idl_default_button=="RIGHT")push_but=push_but_R;
     if(idl_default_button=="LEFT")push_but=push_but_L;
     if(idl_default_button=="BOTH")push_but=push_but_L+push_but_R;
     
      if((push_but_R+push_but_L)>0){
    
       
        
       if(push_but==8){limits;if(rot==1)scale,0.9;}
       if(push_but==7){"fun2";if(!is_void(fun2))fun2;}
       if(push_but==6){"fun1";if(!is_void(fun1))fun1;}
       if(push_but==5){switch_ro_axis;}
      
       
       if(push_but==4){fun3;}
       if(push_but_R==3){change_pal,1;}
       if(push_but_L==3){change_pal,-1;}
   
       if(push_but==2){
         write,"End";return 1;
       }
       
       if(push_but==1){                  
         flag_stop=0;
         //write,"Start";
         animate,1;
         write,"Start";
       }
       
      }

     if(push_but_L + push_but_R ==0){
       if(bu=="3_click"){
         amp=1.3;
         idl_zoom,amp,li;       
       }
       
       if((bu=="3_Ctrl_click")+(bu=="3_Ctrl_drag")){
         flag_stop=0;            
         animate,1;
         write,"Start";
       }

       

       if((bu=="3_Shift_click")+(bu=="3_Shift_drag")){
         
       xb=mouse(1, 2,"[ctrl+right]: enter command\n[right]: switch rotation mode\n[shift+right]: end \n choice: ");

       bub=get_push_name(xb,0,1000);
       bub;
       if(bub=="3_Ctrl_click"){"fun3";fun3;}
       if(bub=="3_click")switch_ro_axis;
       if(bub=="3_Shift_click"){write,"End";return 1;}
     }
      
          
     if((bu=="2_Shift_click"))limits;
     if((bu=="2_Shift_drag"))idl_move,x,li;

     
     if((bu=="1_click")){amp=1.0/1.3;idl_zoom,amp,li;}
     if((bu=="1_drag")){idl_zoom_smooth,x,li;}
     if((bu=="1_Ctrl_click"))scale,0.9;
     
     if(rot==1){
       if((bu=="3_Ctrl_click")){if(rot_hist==0)idl_rotation=0;}
       if((bu=="3_Ctrl_drag"))idl_set_rotation,x,li,ro_amp;
      
       if((bu=="1_Ctrl_drag")){idl_rot3,x,li;draw3,1;}

        }
     }
  }
  
  idl_old_lim=limits();
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

