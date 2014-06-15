unit NewtRaphInterval;

interface

uses uTExtendedX87,
  System.SysUtils,
  System.Classes,
  Windows,
  System.Math,
  IntervalArithmetic32and64;

type Extended = TExtendedX87;


type fx = function (x : interval) : interval;

function NewtonRaphsonInterval (var x     : interval;
                        f,df,d2f  : fx;
                        mit       : Integer;
                        eps       : Extended;
                        var fatx  : interval;
                        var it,st : Integer) : interval;


implementation

function iabs(x : interval) : interval;
begin
  if (x.a <= 0) and (x.b >= 0) then
  begin
    iabs.a := 0;
    if x.b > -x.a then
      iabs.b := x.b
    else
      iabs.b := x.a

  end
  else if x.b < 0 then
  begin
    iabs.a := -x.b;
    iabs.b := -x.a;
  end
  else
  begin
    iabs.a := x.a;
    iabs.b := x.b;
  end;
end;

function less(x, y : interval) : boolean;
begin
  if (x.a < y.a) and (x.b < y.b) then
  less := true
  else
  less := false;
end;

function lesseq(x,y : interval) : boolean;
begin
  if (x.a <= y.a) and (x.b <= y.b) then
  lesseq := true
  else
  lesseq := false;
  
end;

function more(x, y: interval) : boolean;
begin
  if lesseq(x,y) then
  more := false
  else
  more := true;
end;

function moreeq(x, y: interval) : boolean;
begin
  if less(x,y) then
  moreeq := false
  else
  moreeq := true;
end;

function isqrt(x : interval) : interval;
begin
  isqrt.a := sqrt(x.a);
  isqrt.b := sqrt(x.b);
end;




function NewtonRaphsonInterval (var x     : interval;
                        f,df,d2f  : fx;
                        mit       : Integer;
                        eps       : Extended;
                        var fatx  : interval;
                        var it,st : Integer) : interval;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function NewtonRaphson finds an approximate value of the root of     }
{  the equation f(x)=0 by the Newton-Raphson second order method.           }
{  Data:                                                                    }
{    x   - initial approximation to the root (changed on exit),             }
{    f   - a Turbo Pascal function which for the given value x evaluates    }
{          f(x),                                                            }
{    df  - a Turbo Pascal function which for the given value x evaluates    }
{          df(x)/dx,                                                        }
{    d2f - a Turbo Pascal function which evaluates the second derivative of }
{          f(x) with respect to x at the given point x,                     }
{    mit - maximum number of iterations in the method,                      }
{    eps - relative accuracy of the solution.                               }
{  Results:                                                                 }
{    NewtonRaphson(x,f,df,d2f,mit,eps,fatx,it,st) - approximate value of    }
{                                                    the root,              }
{    fatx                                          - the value of the       }
{                                                    function f(x) at the   }
{                                                    approximate root,      }
{    it                                            - number of iterations.  }
{  Other parameters:                                                        }
{    st - a variable which within the function NewtonRaphson is assigned    }
{         the value of:                                                     }
{           1, if mit<1,                                                    }
{           2, if during the calculations the second derivative of f with   }
{              respect to x at a point x is equal to zero,                  }
{           3, if the given accuracy eps is not achieved in mit iteration   }
{              steps,                                                       }
{           4, if during the calculations sqr(df(x))-2*f(x)*d2f(x)<0 at a   }
{              point x,                                                     }
{           0, otherwise.                                                   }
{         Note: If st=1,2 or 4, then                                        }
{               NewtonRaphson(x,f,df,d2f,mit,eps,fatx,st) is not            }
{               calculated, and if st=3, then                               }
{               NewtonRaphson(x,f,df,d2f,mit,eps,fatx,st) yields the last   }
{               approximation to the root.                                  }
{  Unlocal identifier:                                                      }
{    fx - a procedural-type identifier defined as follows                   }
{           type fx = function (x : Extended) : Extended;                   }
{  Note: Any function passed as a parameter should be declared with a far   }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var dfatx,d2fatx,p,q,r,v,w,xh,x1,x2 : interval;
va,vb,wa,wb : Extended;
begin
  if mit<1
    then st:=1
    else begin
           st:=3;
           it:=0;
           repeat
             it:=it+1;
             fatx:=f(x); //18.5856
             dfatx:=df(x); //20.592
             d2fatx:=d2f(x); //48.08
//             p:=dfatx*dfatx-2*fatx*d2fatx;

             p:= imul(dfatx,dfatx);  // 424.030464
             q:= imul(fatx,d2fatx); // 893.595648
             r:= imul(int_read('2'),q); // 1787,191296
             p := isub(p,r);  // -1364.160932
             if (p.a<0) and (p.b<0)
               then st:=4
             else if (d2fatx.a<=0) and (d2fatx.b>=0)
               then st:=2
             else begin
                 xh:=x;
                 wa := abs(xh.a);
                 wb := abs(xh.b);
                 w:=iabs(xh);
                 p:=isqrt(p);
                 // x1:=x-(dfatx-p)/d2fatx;
                 x1 := isub(x,idiv(isub(dfatx,p),d2fatx));
                 // x2:=x-(dfatx+p)/d2fatx;
                 x2 := isub(x,idiv(iadd(dfatx,p),d2fatx));
                 if more(iabs(isub(x2,xh)),iabs(isub(x1,xh)))
                   then x:=x1
                   else x:=x2;
                 va := abs(x.a);
                 vb := abs(x.b);
                 if va < wa then va := wa;
                 if vb < vb then vb := wb;

                 v:=iabs(x);
//                 if less(v,w)
//                   then v:=w;

                 if (va=0) and (vb=0)
                   then st:=0
                 else if (abs(x.a-xh.a)/va<=eps) and (abs(x.b-xh.b)/vb<=eps) then st:=0

//                   else if (idiv(iabs(isub(x,xh)),v).a <= eps) and (idiv(iabs(isub(x,xh)),v).b <= eps)
//                          then st:=0
               end
           until (it=mit) or (st<>3)
         end;
  if (st=0) or (st=3)
    then begin
           NewtonRaphsonInterval:=x;
           fatx:=f(x)
         end
end;
end.
