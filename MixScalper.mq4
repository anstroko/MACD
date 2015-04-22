
#property copyright "AlexanderS"
extern string Пapаметры=" Параметры советника";
extern int TP_5=10;
extern int SL_5=40;
extern int filtr_5=2;
extern int MA_5=150;
extern int WPR_5=21;
extern int CCI_5=16;
extern int TP_15=10;
extern int SL_15=40;
extern int filtr_15=2;
extern int MA_15=150;
extern int WPR_15=21;
extern int CCI_15=16;
extern int TP_30=10;
extern int SL_30=40;
extern int filtr_30=2;
extern int MA_30=150;
extern int WPR_30=21;
extern int CCI_30=16;
extern int TP_60=10;
extern int SL_60=40;
extern int filtr_60=2;
extern int MA_60=150;
extern int WPR_60=21;
extern int CCI_60=16;
extern double lot = 0.03;
extern int CloseAt_5=4;
extern int CloseAt_15=4;
extern int CloseAt_30=4;
extern int CloseAt_60=4;
extern int Magic_Number = 68705;
extern int Slipage=3;
extern int SleepTime=2;



int Start5;
int Start15;
int Start30;
int Start60;
int k;
bool BuTranz=false;
double Stop;
bool flag_sell=false,flag_buy=false;
int i;
bool NewTraid;
bool TraidToday;
bool OpenOrder_60=false;
bool OpenOrder_30=false;
bool OpenOrder_15=false;
bool OpenOrder_5=false;
int init()
{
   if((Digits==3)||(Digits==5)) { k=10;}
   if((Digits==4)||(Digits==2)) { k=1;}
   return(0);
}

int deinit()
{
   return(0);
}

int start()
{
 ObjectCreate("label_object1",OBJ_LABEL,0,0,0);
ObjectSet("label_object1",OBJPROP_CORNER,4);
ObjectSet("label_object1",OBJPROP_XDISTANCE,10);
ObjectSet("label_object1",OBJPROP_YDISTANCE,10);
//ObjectSetText("label_object1","WPR="+iWPR(NULL,0,WPR,0)+";CCI="+iCCI(Symbol(),0,CCI,PRICE_TYPICAL,0),12,"Arial",Red);



  
  if(!isNewBar())return(0);
if (Start5!=0){Start5=Start5-1;}
   OpenOrder_5=false;
  if ((Minute()==15)||(Minute()==30)||(Minute()==45)||(Minute()==00)){  OpenOrder_15=false;}
 if ((Minute()==30)||(Minute()==00)) {   OpenOrder_30=false;}
 if ((Minute()==00))  {  OpenOrder_60=false;}
int total=OrdersTotal();
     for(int in=0;in<OrdersTotal();in++)
     {      if(OrderSelect(in,SELECT_BY_POS)==true)
        {
         if((OrderSymbol()==Symbol())&&(OrderMagicNumber()==Magic_Number) )
           {
           if ((OrderType()==OP_BUY)&&(OrderComment()=="M5")){OpenOrder_5=true; if ((OrderProfit()>0)&&(Start5==0)){OrderClose(OrderTicket(),OrderLots(),Bid,3*k,Black);}
           }
            if ((OrderType()==OP_BUY)&&(OrderComment()=="M15")&&((Minute()==15)||(Minute()==30)||(Minute()==45)||(Minute()==00))){OpenOrder_15=true; if (Start15!=0){Start15=Start15-1;} if ((OrderProfit()>0)&&(Start15==0)){OrderClose(OrderTicket(),OrderLots(),Bid,3*k,Black);}
           }
             if ((OrderType()==OP_BUY)&&(OrderComment()=="M30")&&((Minute()==30)||(Minute()==00))){OpenOrder_30=true; if (Start30!=0){Start30=Start30-1;} if ((OrderProfit()>0)&&(Start30==0)){OrderClose(OrderTicket(),OrderLots(),Bid,3*k,Black);}
           }
             if ((OrderType()==OP_BUY)&&(OrderComment()=="M60")&&(Minute()==00)){OpenOrder_60=true; if (Start60!=0){Start60=Start60-1;} if ((OrderProfit()>0)&&(Start60==0)){OrderClose(OrderTicket(),OrderLots(),Bid,3*k,Black);}
           }
           if ((OrderType()==OP_SELL)&&(OrderComment()=="M5")){OpenOrder_5=true; if ((OrderProfit()>0)&&(Start5==0)){OrderClose(OrderTicket(),OrderLots(),Ask,3*k,Black);}
           }
           if ((OrderType()==OP_SELL)&&(OrderComment()=="M15")&&((Minute()==15)||(Minute()==30)||(Minute()==45)||(Minute()==00))){OpenOrder_15=true; if (Start15!=0){Start15=Start15-1;}if ((OrderProfit()>0)&&(Start15==0)){OrderClose(OrderTicket(),OrderLots(),Ask,3*k,Black);}
           }
            if ((OrderType()==OP_SELL)&&(OrderComment()=="M30")&&((Minute()==30)||(Minute()==00))){OpenOrder_30=true; if (Start30!=0){Start30=Start30-1;}if ((OrderProfit()>0)&&(Start30==0)){OrderClose(OrderTicket(),OrderLots(),Ask,3*k,Black);}
           }
           if ((OrderType()==OP_SELL)&&(OrderComment()=="M60")&&(Minute()==00)){OpenOrder_60=true; if (Start60!=0){Start60=Start60-1;}if ((OrderProfit()>0)&&(Start60==0)){OrderClose(OrderTicket(),OrderLots(),Ask,3*k,Black);}
           }
            }
    }
     }
   if ((Start5!=0)&&(OpenOrder_5==false)){Start5=0;}  
      if ((Start15!=0)&&(OpenOrder_5==false)){Start5=0;}    
        if ((Start30!=0)&&(OpenOrder_30==false)){Start30=0;}  
          if ((Start60!=0)&&(OpenOrder_60==false)){Start60=0;}      
  if ((OpenOrder_5==false)&&((iMA(NULL,0,MA_5,0,MODE_SMA,PRICE_CLOSE,1)+filtr_5*Point*k)<Close[1])&&(iATR(NULL,0,22,1)>0.0002)&&(iWPR(NULL,0,WPR_5,1)<-95)&&(iCCI(Symbol(),0,CCI_5,PRICE_TYPICAL,1)<-95)) { 
  Start5=CloseAt_5;
    Print("Открываемся на buy m5");
    RefreshRates();
  if(    OrderSend(Symbol(),OP_BUY,lot,Ask,Slipage*k,Ask-SL_5*Point*k,Ask+TP_5*Point*k,"M5",Magic_Number,0,Blue) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }
  }
  
  if ((Minute()==15)||(Minute()==30)||(Minute()==45)||(Minute()==00)){
    if ((OpenOrder_15==false)&&((iMA(NULL,15,MA_15,0,MODE_SMA,PRICE_CLOSE,1)+filtr_15*Point*k)<Close[1])&&(iATR(NULL,15,22,1)>0.0002)&&(iWPR(NULL,15,WPR_15,1)<-95)&&(iCCI(Symbol(),15,CCI_15,PRICE_TYPICAL,1)<-95)) { 
  Start15=CloseAt_15;
  Print("Открываемся на buy m15");
  RefreshRates();
  if(    OrderSend(Symbol(),OP_BUY,lot,Ask,Slipage*k,Ask-SL_15*Point*k,Ask+TP_15*Point*k,"M15",Magic_Number,0,Blue) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }
  }}
   if ((Minute()==30)||(Minute()==00)) {
    if ((OpenOrder_30==false)&&((iMA(NULL,30,MA_30,0,MODE_SMA,PRICE_CLOSE,1)+filtr_30*Point*k)<Close[1])&&(iATR(NULL,30,22,1)>0.0002)&&(iWPR(NULL,30,WPR_30,1)<-95)&&(iCCI(Symbol(),30,CCI_30,PRICE_TYPICAL,1)<-95)) { 
  Start30=CloseAt_30;
    Print("Открываемся на buy m30");
    RefreshRates();
  if(    OrderSend(Symbol(),OP_BUY,lot,Ask,Slipage*k,Ask-SL_30*Point*k,Ask+TP_30*Point*k,"M30",Magic_Number,0,Blue) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }
  }}
   if ((Minute()==00)) {
    if ((OpenOrder_60==false)&&((iMA(NULL,60,MA_60,0,MODE_SMA,PRICE_CLOSE,1)+filtr_60*Point*k)<Close[1])&&(iATR(NULL,60,22,1)>0.0002)&&(iWPR(NULL,60,WPR_60,1)<-95)&&(iCCI(Symbol(),60,CCI_60,PRICE_TYPICAL,1)<-95)) { 
  Start60=CloseAt_60;
    Print("Открываемся на buy m60");
    RefreshRates();
  if(    OrderSend(Symbol(),OP_BUY,lot,Ask,Slipage*k,Ask-SL_60*Point*k,Ask+TP_60*Point*k,"M60",Magic_Number,0,Blue) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }
  }}
  
  
   if ((OpenOrder_5==false)&&((iMA(NULL,0,MA_5,0,MODE_SMA,PRICE_CLOSE,1)-filtr_5*Point*k)>Close[1])&&(iATR(NULL,0,22,1)>0.0002)&&(iWPR(NULL,0,WPR_5,1)>-5)&&(iCCI(Symbol(),0,CCI_5,PRICE_TYPICAL,1)>90)) { 
   Start5=CloseAt_5;
     Print("Открываемся на sell m5");
     RefreshRates();
  if(    OrderSend(Symbol(),OP_SELL,lot,Bid,Slipage*k,Bid+SL_5*Point*k,Bid-TP_5*Point*k,"M5",Magic_Number,0,Red) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }
  } 
  if ((Minute()==15)||(Minute()==30)||(Minute()==45)||(Minute()==00)){
  if ((OpenOrder_15==false)&&((iMA(NULL,15,MA_15,0,MODE_SMA,PRICE_CLOSE,1)-filtr_15*Point*k)>Close[1])&&(iATR(NULL,15,22,1)>0.0002)&&(iWPR(NULL,15,WPR_15,1)>-5)&&(iCCI(Symbol(),15,CCI_15,PRICE_TYPICAL,1)>90)) { 
   Start15=CloseAt_15;
        Print("Открываемся на sell m15");
        RefreshRates();
  if(    OrderSend(Symbol(),OP_SELL,lot,Bid,Slipage*k,Bid+SL_15*Point*k,Bid-TP_15*Point*k,"M15",Magic_Number,0,Red) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }
  } }
   if ((Minute()==30)||(Minute()==00)) {
    if ((OpenOrder_30==false)&&((iMA(NULL,30,MA_30,0,MODE_SMA,PRICE_CLOSE,1)-filtr_30*Point*k)>Close[1])&&(iATR(NULL,30,22,1)>0.0002)&&(iWPR(NULL,30,WPR_30,1)>-5)&&(iCCI(Symbol(),30,CCI_30,PRICE_TYPICAL,1)>90)) { 
   Start30=CloseAt_30;
        Print("Открываемся на sell m30");
        RefreshRates();
  if(    OrderSend(Symbol(),OP_SELL,lot,Bid,Slipage*k,Bid+SL_30*Point*k,Bid-TP_30*Point*k,"M30",Magic_Number,0,Red) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }
  } }
   if ((Minute()==00)) {
    if ((OpenOrder_60==false)&&((iMA(NULL,60,MA_60,0,MODE_SMA,PRICE_CLOSE,1)-filtr_60*Point*k)>Close[1])&&(iATR(NULL,60,22,1)>0.0002)&&(iWPR(NULL,60,WPR_60,1)>-5)&&(iCCI(Symbol(),60,CCI_60,PRICE_TYPICAL,1)>90)) { 
   Start60=CloseAt_60;
           Print("Открываемся на sell m60");
           RefreshRates();
  if(    OrderSend(Symbol(),OP_SELL,lot,Bid,Slipage*k,Bid+SL_60*Point*k,Bid-TP_60*Point*k,"M60",Magic_Number,0,Red) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }
  }   }
  
   Sleep(SleepTime*100);

     

   
   
   
   
  if(
  Orders_Total_by_type(OP_BUY, Magic_Number, Symbol()) > 0)

   
 if(
 Orders_Total_by_type(OP_SELL, Magic_Number, Symbol()) > 0)
  
   
   return(0);
  }
//+------------------------------------------------------------------+

bool isNewBar()
  {
  static datetime BarTime;  
   bool res=false;
    
   if (BarTime!=Time[0]) 
      {
         BarTime=Time[0];  
         res=true;
      } 
   return(res);
  }
  
//---- Возвращает количество ордеров указанного типа ордеров ----//
int Orders_Total_by_type(int type, int mn, string sym)
{
   int num_orders=0;
   for(int i= OrdersTotal()-1;i>=0;i--)
   {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderMagicNumber() == mn && type == OrderType() && sym==OrderSymbol())
         num_orders++;
   }
   return(num_orders);
}

