//+------------------------------------------------------------------+
//|                                                      MyNewEA.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#include <Trade\Trade.mqh>

#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

input int Magnumber = 1234;
input double Lots = 0.01;
input int TP = 50;
input int SL = 50;

CTrade trade;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(TerminalInfoInteger(TERMINAL_CONNECTED) && IsMarketOpen())
     {
      OpenBuy();
      OpenSell();
     }
   else
     {
      Print("No connection or market is closed. Orders will not be opened.");
     }
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
  }
//+------------------------------------------------------------------+
//| Function to check if market is open                              |
//+------------------------------------------------------------------+
bool IsMarketOpen()
  {
   datetime currentTime = TimeCurrent();
   MqlDateTime timeStruct;
   TimeToStruct(currentTime, timeStruct);

   int dayOfWeek = timeStruct.day_of_week;
   int hour = timeStruct.hour;

   // ตลาดเปิดวันจันทร์ถึงศุกร์ (ปรับตามตลาดที่คุณต้องการ)
   return (dayOfWeek >= 1 && dayOfWeek <= 5 && hour >= 0 && hour < 24);
  }
//+------------------------------------------------------------------+
//| Function to open a sell order                                    |
//+------------------------------------------------------------------+
void OpenSell()
  {
   double sl = 0, tp = 0;
   double bid = SymbolInfoDouble(Symbol(), SYMBOL_BID);

   if (TP != 0) tp = bid - TP * Point();
   if (SL != 0) sl = bid + SL * Point();

   trade.SetExpertMagicNumber(Magnumber);  
   if (!trade.Sell(Lots, Symbol(), bid, sl, tp, "SELL"))
      Print("Failed to open Sell order. Error: ", GetLastError());
  }
//+------------------------------------------------------------------+
//| Function to open a buy order                                     |
//+------------------------------------------------------------------+
void OpenBuy()
  {
   double sl = 0, tp = 0;
   double ask = SymbolInfoDouble(Symbol(), SYMBOL_ASK);

   if (TP != 0) tp = ask + TP * Point();
   if (SL != 0) sl = ask - SL * Point();

   trade.SetExpertMagicNumber(Magnumber);
   if (!trade.Buy(Lots, Symbol(), ask, sl, tp, "BUY"))
      Print("Failed to open Buy order. Error: ", GetLastError());
  }
