pragma solidity 0.4.22;     //編譯器版本宣告

contract ModifierDemo{      //合約宣告，合約內容在大括號內{}
    address owner;          //狀態變數
    int a = 90;

    modifier modifier1 (int b){     //function modifier函數修飾子
        int c = b;      //執行c=b
        _;              //先跑後面的程式(在本程式中的setA是繼續執行在後面的函數修飾子modifier2)
        c = a;          //跑完後面的程式再執行c=a和a=80
        a = 80;
    }

    modifier modifier2 {        //function modifier函數修飾子
        int c = a;      //執行c=a
        _;              //跑後面的程式(在本程式中的setA是繼續執行在後面的函數修飾子modifier3)
    }

    modifier modifier3 {        //function modifier函數修飾子
        a = 70;         //執行a=70
        return;         
        _;              //先跑後面的程式(在本程式中的setA是繼續執行在後面的函數修飾子modifier3)
        a = 60;         //跑完後面的程式再執行
    }

    modifier modifier4{         //function modifier函數修飾子
        int c = a;      //執行c=a
        _;              //跑後面的程式(在本程式中的setA是繼續執行在後面的setA內部的程式)
    }

    constructor() public {      //建構式(只有合約部屬時會執行)
        owner = msg.sender;     //狀態變數記錄合約部屬人位址
    }

    function setA() public modifier1(a) modifier2 modifier3 modifier4{      //函數宣告會先執行上面的函數修飾子modifier1~4再執行內容
        a = 50;         //執行a=50
    }

    function getA() public view returns(int){       //函數宣告為public且函數內不會變更狀態，會回傳一個int的值
        return a;           //回傳a值
    }
}