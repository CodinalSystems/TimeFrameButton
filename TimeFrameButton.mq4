#property copyright "Codinal Systems"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window


enum ButtonType{
   TYPE_1 = 0,//縦に展開
   TYPE_2//横に展開
};

enum CornerType{
   CORNER_1 = 0,//左上
   CORNER_2,//左下
   CORNER_3,//右上
   CORNER_4//右下
};


input string buttonSetting = "---------------ボタン設定---------------"; //▼ボタン
input CornerType cornerType = CORNER_1;//ボタンの位置
input ButtonType buttonType = TYPE_1;//ボタンの展開方向
input int addPosX = 0;//x座標
input int addPosY = 0;//y座標

input string periodMargin=""; //　
input string periodSetting = "---------------時間軸設定---------------"; //▼時間軸
input bool is1M = true;//M1
input bool is5M = true;//M5
input bool is15M = true;//M15
input bool is30M = true;//M30
input bool is1H = true;//H1
input bool is4H = true;//H4
input bool is1D = true;//D1

input string colorMargin=""; //　
input string colorSetting = "---------------カラー設定---------------"; //▼カラー
input color borderColor = clrWhite;//枠線色
input color textColor = clrWhite;//文字色


bool isPeriod[7];
string periodName[7] = {"M1", "M5", "M15", "M30", "H1", "H4", "D1"};
int periodValue[7] = {1, 5, 15, 30, 60, 240, 1440};
bool isClose = true;


int OnInit(){

   isPeriod[0]= is1M;
   isPeriod[1] = is5M;
   isPeriod[2] = is15M;
   isPeriod[3] = is30M;
   isPeriod[4] = is1H;
   isPeriod[5] = is4H;
   isPeriod[6] = is1D;

   SetButton();

   return(INIT_SUCCEEDED);
}


void OnDeinit(const int reason){
   ObjectsDeleteAll();
}


void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   string disc = "";
   if(id==CHARTEVENT_OBJECT_CLICK){
      string clickedChartObject = sparam; 
      
      int index = ArraySarch(periodName, clickedChartObject);
      if (index != -1){
         for (long chartId = ChartFirst(); chartId != -1; chartId = ChartNext(chartId)){
            ChartSetSymbolPeriod(chartId, ChartSymbol(chartId), periodValue[index]);
         }
      }
      
      if (clickedChartObject == "Close-btn"){
         
         string closeBtnText;
         int visibility;
      
         if (isClose){
         
            closeBtnText = "+";
            visibility = -1;
            isClose = false;
         
         }else{
            closeBtnText = "-";
            visibility = 0;
            isClose = true;
         }
         
         ObjectSetString(0, "Close-btn", OBJPROP_TEXT, closeBtnText);
         for (int i = 0; i < 7; i++){
            ObjectSetInteger(0,  periodName[i] + "-btn", OBJPROP_TIMEFRAMES , visibility);  
         }
      }    
   }
}


int ArraySarch(string &array[], string value){
   int index = -1;
   for (int i = 0; i < ArraySize(array); i++){
      if(array[i] + "-btn" == value){
         index = i;
      }
   }
   return index;
}


void SetButton(){

   int btnSizeX = 50; int btnSizeY = 20;
   int closeX, closeY;
   int positionX, positionY, posDiff, anchor;
   
   if (cornerType == 0){
   
      closeX = 55 - btnSizeX;
      closeY = 23 - btnSizeY;
      anchor = CORNER_LEFT_UPPER;
   
      if (buttonType == 0){
      
         positionX = 55 - btnSizeX;
         positionY = 46 - btnSizeY;
         posDiff = 23;
      }
   
      if (buttonType == 1){
   
         positionX = 108 - btnSizeX;
         positionY = 23 - btnSizeY;
         posDiff = 53;
      }   
   
   }
   
   if (cornerType == 1){
   
      closeX = 55 - btnSizeX;
      closeY = 23;
      anchor = CORNER_LEFT_LOWER;
   
      if (buttonType == 0){
      
         positionX = 55 - btnSizeX;
         positionY = 46;
         posDiff = 23;
      }
   
      if (buttonType == 1){
   
         positionX = 108 - btnSizeX;
         positionY = 23;
         posDiff = 53;
      }
   }
   
   if (cornerType == 2){
   
      closeX = 55;
      closeY = 23 - btnSizeY;
      anchor = CORNER_RIGHT_UPPER;
   
      if (buttonType == 0){
      
         positionX = 55;
         positionY = 46 - btnSizeY;
         posDiff = 23;
      }
   
      if (buttonType == 1){
   
         positionX = 108;
         positionY = 23 - btnSizeY;
         posDiff = 53;
      }
   }
   
   if (cornerType == 3){
      
      closeX = 55;
      closeY = 23;
      anchor = CORNER_RIGHT_LOWER;
   
      if (buttonType == 0){
      
         positionX = 55;
         positionY = 46;
         posDiff = 23;
      }
   
      if (buttonType == 1){
   
         positionX = 108;
         positionY = 23;
         posDiff = 53;
      }
   } 
   
   for (int i = 0; i < 7; i++){
      if (!(isPeriod[i])) continue;
      CreateButton(periodName[i] + "-btn", positionX + addPosX, positionY + addPosY, btnSizeX, btnSizeY, periodName[i], anchor);
      if (buttonType == 0){
         positionY += posDiff;
      }
      if (buttonType == 1){
         positionX += posDiff;
      }
      CreateButton("Close-btn", closeX + addPosX, closeY + addPosY, btnSizeX, btnSizeY, "-", anchor);
   }
}


void CreateButton(string objName, int positionX, int positionY, int sizeX, int sizeY, string text, int anchor){

      ObjectCreate(objName, OBJ_EDIT, 0, 0, 0);
      ObjectSetInteger(0, objName, OBJPROP_BACK, True); 
      ObjectSetInteger(0, objName, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, objName, OBJPROP_READONLY, true); 
      ObjectSetInteger(0, objName, OBJPROP_CORNER, anchor);
      ObjectSetInteger(0, objName, OBJPROP_BORDER_COLOR, borderColor);
      ObjectSetInteger(0, objName, OBJPROP_COLOR, textColor);
      ObjectSetInteger(0, objName, OBJPROP_BGCOLOR, clrNONE);
      ObjectSetString(0, objName, OBJPROP_TEXT, text);  
      ObjectSetString(0, objName, OBJPROP_FONT, "Meiryo UI");  
      ObjectSetInteger(0, objName, OBJPROP_BGCOLOR, clrNONE);
      ObjectSetInteger(0, objName, OBJPROP_XDISTANCE, positionX); 
      ObjectSetInteger(0, objName, OBJPROP_YDISTANCE, positionY);
      ObjectSetInteger(0, objName, OBJPROP_XSIZE, sizeX); 
      ObjectSetInteger(0, objName, OBJPROP_YSIZE, sizeY);
      ObjectSetInteger(0, objName, OBJPROP_BORDER_TYPE, BORDER_FLAT); 
      ObjectSetInteger(0, objName, OBJPROP_ALIGN, ALIGN_CENTER);
}


int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   return(rates_total);
}