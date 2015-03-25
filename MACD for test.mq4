      //+------------------------------------------------------------------+
//|                                             SunExpert ver0.6.mq4 |
//|                                                Alexander Strokov |
//|                                    strokovalexander.fx@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Alexander Strokov"
#property link      "strokovalexander.fx@gmail.com"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization functi                                  |
//+------------------------------------------------------------------+
extern string Пapаметры="Настройки советника";
extern int Magic_Number=3213;
extern int TP=25;
extern int SL=25;
extern double Lot=0.1;
extern int filtr=2;
extern string Параметры4="Signal Candle MACD (если 1 - старая версия, если 2 новая версия MACD)";
extern int SignalCandle=2;
extern bool TradeHighLow=true;
extern string Параметры1="Параметры MACD";
extern int MACD1=12;
extern int MACD2=26;
extern int MACD3=9;
extern string Пapаметры2="Параметры тралинга";
extern bool BuyTralEnd=true;
extern bool SellTralEnd=true;
extern double StartTralPoints=30;
extern double SizeTralPoints=15;
extern string Пapаметры3="Параметры MA";
extern bool UsingMA=true;
extern int PeriodMA=50;
extern string Пapаметры4="Таймфреймы МА:PERIOD_D1,PERIOD_H4,PERIOD_H1";
extern string TimeFrameMA=PERIOD_D1;



extern string Coments;

double CurrentMACD;
int k;
bool TradeBuy;
bool TradeSell;
double OpenBuyPrice;
double OpenSellPrice;
bool BuyTrallOk;
bool SellTrallOk;
bool BuySignalOne;
bool SellSignalOne;
bool buymarket;
bool sellmarket;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {

   if((Digits==3)||(Digits==5)) { k=10;}
   if((Digits==4)||(Digits==2)) { k=1;}

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {

 
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   ObjectCreate("label_object1",OBJ_LABEL,0,0,0);
ObjectSet("label_object1",OBJPROP_CORNER,4);
ObjectSet("label_object1",OBJPROP_XDISTANCE,10);
ObjectSet("label_object1",OBJPROP_YDISTANCE,10);
ObjectSetText("label_object1","Предыдущее значение MACD ="+DoubleToStr(iMACD(NULL,0,MACD1,MACD2,MACD3,PRICE_CLOSE,MODE_MAIN,1),4),14,"Arial",Red);
  
ObjectCreate("label_object2",OBJ_LABEL,0,0,0);
ObjectSet("label_object2",OBJPROP_CORNER,4);
ObjectSet("label_object2",OBJPROP_XDISTANCE,10);
ObjectSet("label_object2",OBJPROP_YDISTANCE,30);
ObjectSetText("label_object2","Текущее значение MACD ="+CurrentMACD,14,"Arial",Red);
  
  
  TradeBuy=false;TradeSell=false;
    for(int in=0;in<OrdersTotal();in++)
     {      if(OrderSelect(in,SELECT_BY_POS)==true)
        {
         if((OrderSymbol()==Symbol())&&(OrderMagicNumber()==Magic_Number) )
           {
            if(OrderType()==OP_BUY){TradeBuy=true; }
            if(OrderType()==OP_SELL){TradeSell=true;}
           }
        }
     }
    if (TradeBuy==false){BuyTrallOk=false;} 
    if (TradeSell==false){SellTrallOk=false;}

if (buymarket==true){EditBuyOrder();buymarket=false;}    
if (sellmarket==true){EditSellOrder();sellmarket=false;}   
     
if((BuyTralEnd==true)&&(TradeBuy==true))
{BuyTrall();}

if((SellTralEnd==true)&&(TradeSell==true))
{SellTrall();}

     if (SignalCandle==1){
  if ((BuySignalOne==false)&&(TradeBuy==false)&&((iMACD(NULL,0,MACD1,MACD2,MACD3,PRICE_CLOSE,MODE_MAIN,SignalCandle))<0)&&((iMACD(NULL,0,MACD1,MACD2,MACD3,PRICE_CLOSE,MODE_MAIN,(SignalCandle-1)))>0))
  {
  
  BuySignalOne=true;   
  DeleteStop(OP_BUYSTOP);
  if(TradeHighLow==true){OpenBuyPrice=High[1];} else {OpenBuyPrice=Ask;} 
  if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUYSTOP,Lot,OpenBuyPrice+filtr*k*Point,3*k,OpenBuyPrice+filtr*k*Point-SL*k*Point,OpenBuyPrice+filtr*k*Point+TP*k*Point,Coments,Magic_Number,0,Blue) < 0) 
      {Alert("Ошибка открытия позиции № ", GetLastError());Print("Открываемся с рынка"); if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,Coments,Magic_Number,0,Blue)<0)
      {Alert("Произошла ошибка при входе с рынка № ", GetLastError()," Коммент ",Coments);} else{buymarket=true;} }}
 
  }
  if ((SellSignalOne==false)&&(TradeSell==false)&&((iMACD(NULL,0,MACD1,MACD2,MACD3,PRICE_CLOSE,MODE_MAIN,SignalCandle))>0)&&((iMACD(NULL,0,MACD1,MACD2,MACD3,PRICE_CLOSE,MODE_MAIN,(SignalCandle-1)))<0))
  {
   SellSignalOne=true; 
   DeleteStop(OP_SELLSTOP);
      if(TradeHighLow==true){OpenSellPrice=Low[1];}else {OpenSellPrice=Bid;}

    if(IsTradeAllowed()) 
        { if(OrderSend(Symbol(),OP_SELLSTOP,Lot,OpenSellPrice-filtr*k*Point,3*k,OpenSellPrice-filtr*k*Point+SL*k*Point,OpenSellPrice-filtr*k*Point-TP*k*Point,Coments,Magic_Number,0,Red) < 0)
           {Alert("Произошла ошибка",GetLastError());Print("Открываемся с рынка");  if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,Coments,Magic_Number,0,Red)<0)
           {Alert("Произошла ошибка при входе с рынка № ",GetLastError()," Коммент ",Coments);}else{sellmarket=true;} }
        }
  }
  
  
  }

 if(!isNewBar())return(0);
    if (SignalCandle==1){SellSignalOne=false;BuySignalOne=false;}
CurrentMACD=DoubleToStr(iMACD(NULL,0,MACD1,MACD2,MACD3,PRICE_CLOSE,MODE_MAIN,0),4);
if (SignalCandle==2){
  if ((TradeBuy==false)&&((iMACD(NULL,0,MACD1,MACD2,MACD3,PRICE_CLOSE,MODE_MAIN,SignalCandle))<0)&&((iMACD(NULL,0,MACD1,MACD2,MACD3,PRICE_CLOSE,MODE_MAIN,(SignalCandle-1)))>0))

  {
       
    DeleteStop(OP_BUYSTOP);
    if(TradeHighLow==true){OpenBuyPrice=High[1];} else {OpenBuyPrice=Close[1];}
   //    Coments="TP="+IntegerToString(TP)+" SL="+IntegerToString(SL)+" Filtr="+IntegerToString(filtr)+" BuyStartTralPoints="+DoubleToString(StartTralPoints,1)+" BuySizeTralPoints="+DoubleToString(SizeTralPoints,1);
   
  if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUYSTOP,Lot,OpenBuyPrice+filtr*k*Point,3*k,OpenBuyPrice+filtr*k*Point-SL*k*Point,OpenBuyPrice+filtr*k*Point+TP*k*Point,Coments,Magic_Number,0,Blue) < 0) 
      {Alert("Ошибка открытия позиции № ", GetLastError()," Коммент ",Coments);Print("Открываемся с рынка");
      
      if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,Coments,Magic_Number,0,Blue)<0)
      {Alert("Произошла ошибка при входе с рынка № ", GetLastError()," Коммент ",Coments);} else {buymarket=true;} }}
  
  
  }
  
    if ((TradeSell==false)&&((iMACD(NULL,0,MACD1,MACD2,MACD3,PRICE_CLOSE,MODE_MAIN,SignalCandle))>0)&&((iMACD(NULL,0,MACD1,MACD2,MACD3,PRICE_CLOSE,MODE_MAIN,(SignalCandle-1)))<0))

  {
      DeleteStop(OP_SELLSTOP);
      if(TradeHighLow==true){OpenSellPrice=Low[1];}else {OpenSellPrice=Close[1];}
  //Coments="TP="+IntegerToString(TP)+" SL="+IntegerToString(SL)+" Filtr="+IntegerToString(filtr)+" BuyStartTralPoints="+DoubleToString(StartTralPoints,1)+" BuySizeTralPoints="+DoubleToString(SizeTralPoints,1);
 
    if(IsTradeAllowed()) 
        { if(OrderSend(Symbol(),OP_SELLSTOP,Lot,OpenSellPrice-filtr*k*Point,3*k,OpenSellPrice-filtr*k*Point+SL*k*Point,OpenSellPrice-filtr*k*Point-TP*k*Point,Coments,Magic_Number,0,Red) < 0)
           {Alert("Ошибка открытия позиции № ",GetLastError()," Коммент",Coments);Print("Открываемся с рынка");
           
           if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,Coments,Magic_Number,0,Red)<0)
           {Alert("Произошла ошибка при входе с рынка № ",GetLastError()," Коммент ",Coments);}else{sellmarket=true;}
           
           
            }
        }
  
  }
  }
 return(0); }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isNewBar()
  {
   static datetime BarTime;
   bool res=false;

   if(BarTime!=Time[0])
     {
      BarTime=Time[0];
      res=true;
     }
   return(res);
  }

bool DeleteStop (int type){
  for (int i=OrdersTotal()-1; i>=0; i--)
   {
      if (!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) break;
            if ((OrderType()==type  )&&(OrderMagicNumber() == Magic_Number ))    if (IsTradeAllowed()) { if (OrderDelete(OrderTicket())<0) 
            { 
        Alert("Ошибка удаления ордера № ", GetLastError()); 
      }  
            }
    
      
         }
         return(0);} 
         
double BuyTrall()
{
double stp;
 for(int ii=0;ii<OrdersTotal();ii++)
     {
     
      if(OrderSelect(ii,SELECT_BY_POS)==true)
        {
         if((OrderSymbol()==Symbol())&&(OrderMagicNumber()==Magic_Number)&&(OrderType()==OP_BUY))
           {
               if (((Ask-OrderOpenPrice())>(StartTralPoints*Point*k))&&(BuyTrallOk==false)){ BuyTrallOk=true;stp=Ask-(StartTralPoints*Point*k);Print("Начинаем тралить ордер Buy");
                      OrderModify(OrderTicket(),OrderOpenPrice(),stp,OrderTakeProfit(),0,Orange); }
                      
                        OrderSelect(OrderTicket(), SELECT_BY_TICKET);
                      if ((Ask-(SizeTralPoints*Point*k)>OrderStopLoss())&&(BuyTrallOk==true))
                      {stp=Ask-(SizeTralPoints*Point*k);
                      Print("Тралим ордер Buy");        OrderModify(OrderTicket(),OrderOpenPrice(),stp,OrderTakeProfit(),0,Orange); }
     
           }
        }}
        
       
        return(0);}
         
         
         
double SellTrall()
{
double stp;
 for(int ii=0;ii<OrdersTotal();ii++)
     {
     
      if(OrderSelect(ii,SELECT_BY_POS)==true)
        {
         if((OrderSymbol()==Symbol())&&(OrderMagicNumber()==Magic_Number)&&(OrderType()==OP_SELL))
           {
               if (((OrderOpenPrice()-Bid)>(StartTralPoints*Point*k))&&(SellTrallOk==false)){ SellTrallOk=true;stp=Bid+(StartTralPoints*Point*k);Print("Начинаем тралить ордер Sell");
                      OrderModify(OrderTicket(),OrderOpenPrice(),stp,OrderTakeProfit(),0,Orange); }
                      
                        OrderSelect(OrderTicket(), SELECT_BY_TICKET);
                      if ((Bid+(SizeTralPoints*Point*k)<OrderStopLoss())&&(SellTrallOk==true))
                      {stp=Bid+(SizeTralPoints*Point*k);
                      Print("Тралим ордер Sell");        OrderModify(OrderTicket(),OrderOpenPrice(),stp,OrderTakeProfit(),0,Orange); }
     
           }
        }}
        
       
        return(0);} 

double EditBuyOrder()
{
 for(int ii=0;ii<OrdersTotal();ii++)
     {
     
      if(OrderSelect(ii,SELECT_BY_POS)==true)
        {
         if((OrderSymbol()==Symbol())&&(OrderMagicNumber()==Magic_Number)&&(OrderType()==OP_BUY))
           {
     double bSL=OrderOpenPrice()-SL*k*Point;
     double bTP=OrderOpenPrice()+TP*k*Point;
     OrderModify(OrderTicket(),OrderOpenPrice(),bSL,bTP,0,Orange);       
           
}}}
return(0);}

double EditSellOrder()
{
for(int ii=0;ii<OrdersTotal();ii++)
     {
     
      if(OrderSelect(ii,SELECT_BY_POS)==true)
        {
         if((OrderSymbol()==Symbol())&&(OrderMagicNumber()==Magic_Number)&&(OrderType()==OP_SELL))
           {
           
     double sSL=OrderOpenPrice()+SL*k*Point;
     double sTP=OrderOpenPrice()-TP*k*Point;
     OrderModify(OrderTicket(),OrderOpenPrice(),sSL,sTP,0,Orange);    
}}}

return(0);}


/*

if (((Ask-OrderOpenPrice())>(BuyStartTralPoints*Point*k))&&(BuyTrallOk=false)){ BuyTrallOk=true;
                      if (OrderStopLoss()<(OrderOpenPrice()-(BuyStartTralPoints*Point*k)))
                      {stp=OrderOpenPrice()-(BuyStartTralPoints*Point*k);Print("Начинаем тралить ордер Buy");
                      OrderModify(OrderTicket(),OrderOpenPrice(),stp,OrderTakeProfit(),0,Orange); }
                        OrderSelect(OrderTicket(), SELECT_BY_TICKET);
                      if ((OrderStopLoss()+(BuySizeTralPoints*Point*k)+(BuyStartTralPoints*Point*k))<Ask)
                      {stp=OrderStopLoss()+(BuySizeTralPoints*Point*k);
                      Print("Тралим шаг ордера Buy");        OrderModify(OrderTicket(),OrderOpenPrice(),stp,OrderTakeProfit(),0,Orange); }
     
           }}
        }}
        
        
        return(0);}
         
         
         /
double SellTrall()
{
double stp;
 for(int ii=0;ii<OrdersTotal();ii++)
     {
     
      if(OrderSelect(ii,SELECT_BY_POS)==true)
        {
         if((OrderSymbol()==Symbol())&&(OrderMagicNumber()==Magic_Number)&&(OrderType()==OP_SELL))
           {
               if ((OrderOpenPrice()-Bid)>(SellStartTralPoints*Point*k)){
                      if (OrderStopLoss()>(OrderOpenPrice()+(SellStartTralPoints*Point*k)))
                      {stp=OrderOpenPrice()+(SellStartTralPoints*Point*k);Print("Начинаем тралить ордер Sell");
                      OrderModify(OrderTicket(),OrderOpenPrice(),stp,OrderTakeProfit(),0,Orange); }
                      OrderSelect(OrderTicket(), SELECT_BY_TICKET);
                      if ((OrderStopLoss()-(SellSizeTralPoints*Point*k)-(SellStartTralPoints*Point*k))>(Bid))
                      {stp=OrderStopLoss()-(SellSizeTralPoints*Point*k);Print("Тралим шаг ордера Sell");
                              OrderModify(OrderTicket(),OrderOpenPrice(),stp,OrderTakeProfit(),0,Orange); }
       
       
       Sleep(500);
       
       
*/       