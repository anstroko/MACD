//+------------------------------------------------------------------+
//|                                                     Greedily.mq4 |
//|                                    strokovalexander.fx@gmail.com |
//|                                                                  |
//+------------------------------------------------------------------+
extern double TakeProfit=30000;
extern double StopLoss=30000;
extern double Second=1;
extern string Параметры="Параметры тралинга";
extern bool UseTrall=true;
extern double Step=10;
extern double TralProfit=100;
extern bool Lot=0.1;
int k;
bool ItsTrallTime=false;
double StopTrall;
double MaxEquity;
int S=1;
int OnInit()
  {
   if((Digits==3)||(Digits==5)) { k=10;}
   if((Digits==4)||(Digits==2)) { k=1;}
   return(INIT_SUCCEEDED);
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
ObjectSetText("label_object1","Профит Жадности="+TakeProfit+"; Стоп Жадности="+StopLoss,12,"Arial",Red);

ObjectCreate("label_object2",OBJ_LABEL,0,0,0);
ObjectSet("label_object2",OBJPROP_CORNER,4);
ObjectSet("label_object2",OBJPROP_XDISTANCE,10);
ObjectSet("label_object2",OBJPROP_YDISTANCE,30);
ObjectSetText("label_object2","Использование трала="+UseTrall+"; Шаг"+Step+"; Профит трала="+TralProfit+"; Стоп трала="+StopTrall,12,"Arial",Red);
 



if (S==1){
OrderSend(Symbol(),OP_BUY,Lot,Ask,30,NULL,NULL,"M15",1,0,Blue); S=0;
}


if  (GlobalVariableGet("Greedily")==0){ 

if (UseTrall==true){
if (((AccountEquity())>=TakeProfit)&&(ItsTrallTime==false)){ ItsTrallTime=true;MaxEquity=TakeProfit; StopTrall=MaxEquity-TralProfit; Print ("Начинаем тралить прибыль"); }

if (ItsTrallTime==true){
if (AccountEquity()>(MaxEquity+Step)){MaxEquity=MaxEquity+Step;StopTrall=StopTrall+Step;Print ("StopTrall",StopTrall);}
if (AccountEquity()<=StopTrall){ MaxEquity=0; StopTrall=0; ItsTrallTime=false; GoGoProfit();       }
}






}

if (UseTrall==false){
if ((AccountEquity())>=TakeProfit){   

 GlobalVariableSet("Greedily",1);    Sleep(Second*100);
GoGoProfit();
 }

if ((AccountEquity())<=StopLoss){  

 GlobalVariableSet("Greedily",1);    Sleep(Second*100);
GoGoStop();
        
}    
}
}


return(0);}


 
   
double GoGoProfit(){


          for(int it=OrdersTotal()-1; it>=0; it--)
        {
         if((OrderSelect(it,SELECT_BY_POS,MODE_TRADES))&&(OrderType()==OP_BUY)){
              if(OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),3*k,Black)<0)
               {
               Alert("Ошибка удаления ордера № ",GetLastError());
              }  }
              if((OrderSelect(it,SELECT_BY_POS,MODE_TRADES))&&(OrderType()==OP_SELL)){
              if( OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),5*k,Black)<0)
              {
               Alert("Ошибка удаления ордера № ",GetLastError());
              }
            }
        }





  for(int idDel=OrdersTotal()-1; idDel>=0; idDel--)
        {
         if(!OrderSelect(idDel,SELECT_BY_POS,MODE_TRADES)) break;
         if((OrderType()==OP_BUYLIMIT)) if(IsTradeAllowed()) 
           {
            if(OrderDelete(OrderTicket())<0)
              {
               Alert("Ошибка удаления ордера № ",GetLastError());
              }
           }
            if((OrderType()==OP_SELLLIMIT)) if(IsTradeAllowed()) 
           {
            if(OrderDelete(OrderTicket())<0)
              {
               Alert("Ошибка удаления ордера № ",GetLastError());
              }
           }
        }
        
        Alert("Заработано по плану, прекращаем торговлю!");
SendMail("Советник Жадность закрыл профит!!!", "Все ордера закрылись");Sleep(Second*100);
return(0);
}

double GoGoStop()
{          for(int itt=OrdersTotal()-1; itt>=0; itt--)
        {
         if((OrderSelect(itt,SELECT_BY_POS,MODE_TRADES))&&(OrderType()==OP_BUY)){
              if(OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),3*k,Black)<0)
               {
               Alert("Ошибка удаления ордера № ",GetLastError());
              }  }
              if((OrderSelect(itt,SELECT_BY_POS,MODE_TRADES))&&(OrderType()==OP_SELL)){
              if( OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),5*k,Black)<0)
              {
               Alert("Ошибка удаления ордера № ",GetLastError());
              }
            }
            
            
            
           
         
         
        }





  for(int iDel=OrdersTotal()-1; iDel>=0; iDel--)
        {
         if(!OrderSelect(iDel,SELECT_BY_POS,MODE_TRADES)) break;
         if((OrderType()==OP_BUYLIMIT)) if(IsTradeAllowed()) 
           {
            if(OrderDelete(OrderTicket())<0)
              {
               Alert("Ошибка удаления ордера № ",GetLastError());
              }
           }
            if((OrderType()==OP_SELLLIMIT)) if(IsTradeAllowed()) 
           {
            if(OrderDelete(OrderTicket())<0)
              {
               Alert("Ошибка удаления ордера № ",GetLastError());
              }
           }
        }
        Alert("Теряем слишком много, прекращаем торговлю!");
        
SendMail("Советник Жадность закрыл убыток(((", "Все ордера закрылись");Sleep(Second*100);

     return(0); }  
  