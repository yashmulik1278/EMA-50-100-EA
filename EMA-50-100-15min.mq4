//+------------------------------------------------------------------+
//|                                             EMA-50-100-15min.mq4 |
//|                                                           Hawk78 |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Hawk78"
#property link      ""
#property version   "1.00"
#property strict

// Define input parameters
input int ema100Period = 100;
input int ema50Period = 50;
input int stopLossPips = 250;
input int takeProfitPips = 250;

// Define OnTick function
void OnTick()
{
    // Check if there are any open orders
    if (OrdersTotal() > 0)
    {
        return; // Exit the function if there are open orders
    }

    // Calculate EMAs
    double ema100 = iMA(NULL, 0, ema100Period, 0, MODE_EMA, PRICE_CLOSE, 0);
    double ema50 = iMA(NULL, 0, ema50Period, 0, MODE_EMA, PRICE_CLOSE, 0);

    // Buy condition
    if (Ask > ema100)
    {
        // Check if price breaks and closes above 50 EMA
        if (iClose(NULL, 0, 0) > ema50 && iClose(NULL, 0, 1) <= ema50)
        {
            // Open a buy order with stop loss and take profit
            double stopLossLevel = Ask - stopLossPips * Point;
            double takeProfitLevel = Ask + takeProfitPips * Point;

            int ticket = OrderSend(Symbol(), OP_BUY, .05, Ask, 3, stopLossLevel, takeProfitLevel, "Buy Order with SL/TP", 0, 0, Green);
            
            if (ticket > 0)
            {
                Print("Buy Order Placed with SL/TP");
            }
            else
            {
                Print("Error placing buy order with SL/TP. Error code:", GetLastError());
            }
        }
    }

    // Sell condition
    if (Bid < ema100)
    {
        // Check if price breaks and closes below 50 EMA
        if (iClose(NULL, 0, 0) < ema50 && iClose(NULL, 0, 1) >= ema50)
        {
            // Open a sell order with stop loss and take profit
            double stopLossLevel = Bid + stopLossPips * Point;
            double takeProfitLevel = Bid - takeProfitPips * Point;

            int ticket = OrderSend(Symbol(), OP_SELL, 0.05, Bid, 3, stopLossLevel, takeProfitLevel, "Sell Order with SL/TP", 0, 0, Red);
            
            if (ticket > 0)
            {
                Print("Sell Order Placed with SL/TP");
            }
            else
            {
                Print("Error placing sell order with SL/TP. Error code:", GetLastError());
            }
        }
    }
}