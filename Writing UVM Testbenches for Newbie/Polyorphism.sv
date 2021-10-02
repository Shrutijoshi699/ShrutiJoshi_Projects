class employee_data;
integer age;
string name;

function new(input string name,input integer age);
this.age=age;
this.name=name;
$display("Run employee_data constructor");
endfunction

virtual function void run();
$display("Error");
endfunction
endclass 


class hardware extends employee_data;

function new(input string name,input integer age);
super.new(name,age);
$display("Run Hardware constructor");
endfunction

function void run();
$display("Run Hardware");
$display("Hardware engineer age is %0d and name is %0s",this.age,this.name);
endfunction
endclass


class software extends employee_data;

function new(input string name,input integer age);
super.new(name,age);
endfunction

function void run();
$display("Run Software");
$display("Software engineer age is %0d and name is %0s",this.age,this.name);
endfunction
endclass

class factory;
static function employee_data add_record(input string cat,input string name,input int age);

hardware h;
software s;
$display("Run Static Function");
case(cat)
"hardware":begin
h=new(name,age);
return h;
end
"software":begin
s=new(name,age);
return s;
end
default:$stop();
endcase

endfunction

endclass

/*
module tb;
employee_data t;
employee_data t1;
hardware h;
software s;
initial begin
h=new("XYZ",24);
s=new("PQR",23);
t=h;
t1=s;
t.run();
t1.run();
end
endmodule
*/

module tb;
employee_data t;

initial begin
t=factory::add_record("hardware","abc",25);
$display("----------------------------------------------");
t.run();
$display("----------------------------------------------");
end
endmodule
