/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

//-----------------------------------------------------------------------------
// This confidential and proprietary software may be used only as authorized
// by a licensing agreement from Synopsys Inc. In the event of publication,
// the following notice is applicable:
//
// (C) COPYRIGHT 2008 SYNOPSYS INC.  ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//-----------------------------------------------------------------------------
//
// Description : IEEE P1800 Doubly Linked List example
//
//-----------------------------------------------------------------------------


`include "List.svh"

class Packet;
  int _value;
  int _header;
  function int data();
   return(_value);
  endfunction : data
endclass : Packet

function void printIntList(const ref List#(int) intList);
 List_Iterator#(int) iter;
 iter = intList.start();
 while(iter.neq(intList.finish())) 
 begin
  $write("\t Value = %d \n",iter.data());
  iter.next();
  end
endfunction : printIntList

program listUsage;

  List#(int) L1;
  List#(int) L2;
  List#(int) L3;

  List_Iterator#(int) I1;
  List_Iterator#(int) I2;
  List_Iterator#(int) I3;
  List_Iterator#(int) I_handle;

  List#(string) S1;

  List_Iterator#(string) Is;
  List_Iterator#(string) Is1;

  List#(Packet) T1;
  List#(Packet) T2;
		
  List_Iterator#(Packet) It1;
  List_Iterator#(Packet) It2;
		
  Packet t1;
  Packet t2;
  Packet t3;
  Packet t4;
  Packet t5;

  Packet t_handle;


 initial
 begin
  L1 = new();
  L2 = new();
  L3 = new();

  S1 = new();

  T1 = new();
  T2 = new();
		
  t1 = new();
  t2 = new();
  t3 = new();
  t4 = new();
  t5 = new();

  $write("Error Checking T1 for an empty list \n");
  T1.pop_front();

  t1._value = 111;
  T1.push_back(t1);
  t2._value = 112;
  T1.push_back(t2);

  t3._value = 113;
  t4._value =114;
  t5._value = 115;

  It1 = T1.start();
  It1.next();

  T1.insert(It1,t3);
  T1.insert(It1,t4);
  T1.insert(It1,t5);

  $write("Displaying list T1 (of Packets) \n");
  It1 = T1.start();
  while(It1.neq(T1.finish()))
  begin
   t_handle = It1.data();
   $write("\t Value = %d \n", t_handle.data());
   It1.next();
  end

  S1.push_back("a1");
  S1.push_back("a2");

  Is1 = S1.start();
  S1.insert(Is1,"a3");
  S1.insert(Is1,"a4");
  S1.insert(Is1,"a5");

  $write("Displaying list S1 \n");
  Is = S1.start();
  while (Is.neq(S1.finish()))
  begin
   $write("\t Value = %s \n",Is.data());
   Is.next();
  end

  L1.push_back(10);
  L1.push_back(20);
  L1.push_back(30);
  L1.push_back(40);

  I1 = L1.start();
  I1.next(); 
  I1.next();
  $write("\t Value at current iterator pos =%d \n",I1.data());
  L1.erase(I1); 
  I1 = L1.start();
  I1.next();
  $write("\t Value at current iterator pos = %d \n", I1.data());
 
  $write("Displaying list L1 \n");
  I_handle = L1.start();
  while(I_handle.neq(L1.finish())) 
  begin
   $write("\t Value = %d \n", I_handle.data());
   I_handle.next();
  end
  $write("Size of list L1 = %0d \n", L1.size());

  if (L2.empty() == 1) $write("List L2 is empty \n");		
  else $write("List L2 is not empty \n");

  if (L1.empty() == 0) $write("List L1 is not 	empty \n");
  else $write("List L1 is empty \n");
	
  $write("First element of List L1 = %0d \n",L1.front());
  $write("Last element of List L1 = %0d \n",L1.back());

  $write("Printing L1.................\n");
  printIntList(L1);
	
  I3 = L3.start();
  L3.insert(I3, 100);
  L3.insert(I3, 200);
  L3.insert(I3, 300);
  $write("Printing L3.................\n");
  printIntList(L3);
  
  $write("Swapping L1 and L3..........\n");
  L1.swap(L3);
	  
  $write("Printing L1 after swapping.....\n");
	  
  printIntList(L1);
	
  $write("Printing L3 after swapping.....\n");
  printIntList(L3);
	
  L2.push_back(10);
  I2 = L2.start();
  L2.insert(I2, 20);
  L2.insert(I2, 30);
  $write("Printing L2..........\n");
  printIntList(L2);
	
  L1.push_front(50);
  $write("Printing L1 after push_front(50)......\n");
  printIntList(L1); 
	
  L1.push_back(350);
  $write("Printing L1 after push_back(350)......\n");
  printIntList(L1); 
	
  L2.pop_front();
  $write("Printing L2 after poping from the front ....\n");
  printIntList(L2); 
	
  L3.pop_back();
  $write("Printing L3 after poping from the back......\n");
  printIntList(L3); 
  $write("Size of list L3 = %0d \n", L3.size());

  L3.clear();
  $write("Size of List L3 after clearing it = %0d \n", L3.size());
	
  I1 = L3.start();
  L3.erase(I1);
	
  L1.push_front(25);
  L1.push_back(400);
  $write("Printing L1 after inserting 25 and 400 ......\n");
  printIntList(L1); 
	

  I1 = L1.finish();	
  I1.next(); I1.next();
  I1.prev(); 
  I3 = L1.finish(); 
  I3.prev(); I3.prev();
  I3.next(); I3.next(); I3.next();
  $write("Printing L1 after erasing  from %0d to %0d(not included)  ......\n", I1.data(),I3.data());

  L1.erase_range(I1, I3);
  printIntList(L1); 

  I1 = L1.start();
  I1.next();
  L1.insert(I1, 40);
  I1.next();
  L1.insert(I1, 100);	
  L1.insert(I1, 200);
  $write("Printing new List 	L1....................\n");
  printIntList(L1); 


  I2 = L3.start(); I2.next();
  L3.insert(I2, 57);
  L3.insert(I2, 84);
  L3.insert(I2, 24);
  L3.insert(I2, 94);
  L3.insert(I2, 68); 
  $write("Printing L3 after poping from the back......\n");
  printIntList(L3);
  I1 = L1.start();  I1.next(); 
  I3 = L3.finish(); I3.prev();
  $write("Printing L1 after inserting range %0d to %0d(not included) before %0d....\n",I2.data(),I3.data(),I1.data());
	
  L1.insert_range(I1,I2,I3);
  printIntList(L1); 
  
  
  L3.push_back(100);
  $write("Printing L3 after assigning L2 to it......\n");
  L3.set(L2.start(), L2.finish()); 
  printIntList(L3);

  L2.push_back(65);
  L2.push_back(66);
  L2.push_back(67);
  L3.set(L2.start(), L2.finish()); 
  $write("Printing L3 after assigning L2 to it......\n");
  printIntList(L3);
  $write("Size of list L3 = %0d \n", L3.size());

 end

endprogram : listUsage


