
CHIP CPU {

    IN  inM[16],         // M value input  (M = contents of RAM[A])
        instruction[16], // Instruction for execution
        reset;           // Signals whether to re-start the current
                         // program (reset==1) or continue executing
                         // the current program (reset==0).

    OUT outM[16],        // M value output
        writeM,          // Write to M? 
        addressM[15],    // Address in data memory (of M)
        pc[15];          // address of next instruction

    PARTS:

        // ALU Computation

        Mux16(a= ARegisterOut, b= inM, sel= instruction[12], out= ALUY);

        ALU(x= DRegisterOut, 
        y= ALUY, 
        zx= instruction[11], 
        nx= instruction[10], 
        zy= instruction[9], 
        ny= instruction[8], 
        f= instruction[7], 
        no= instruction[6], 
        out= ALUOut, zr= Zero, ng= Negative);

        // REGISTER LOGIC

        // a register logic
        Mux16(a[0..15]=false, b=ALUOut, sel=instruction[5], out=ARegisterALUIn);
        Mux16(a=instruction[0..15], b=ARegisterALUIn, sel=instruction[15], out=ARegisterIn); //outputs a (data for register A) if sel=0

        Not(in=instruction[15], out=NotX);
        Or(a= instruction[5], b= NotX, out= ALoad); // Determine if writing A from either ALU or A inst

        And(a=instruction[4], b=instruction[15], out=DLoad);
        // Registers
        ARegister(in=ARegisterIn, load=ALoad, out=ARegisterOut, out[0..14]=ARegisterOut15); // The A register, seperate ARegisterOut15 for address
        DRegister(in=ALUOut, load=DLoad, out=DRegisterOut); // The D register
	
        // Extra Outputs
        And(a=instruction[3], b=instruction[15], out=writeMOut);
        Not(in=writeMOut, out=tmp1);
        Not(in=tmp1, out=writeM);

        Not16(in=ARegisterOut, out=tmp3); // Simply send the A Register for addressM
        Not16(in=tmp3, out[0..14]=addressM);


        Mux16(a[0..15]=false, b=ALUOut, sel=writeMOut, out=outM);

        // JUMP LOGIC

        // Mux selects

        Not(in= instruction[2], out= lesser1);
        And(a=instruction[1], b=instruction[0], out=check1);
        And(a=check1, b=lesser1, out=MustGreaterEqual); // Jump if >0 or =0 - 011

        Not(in= instruction[0], out= greater1);
        And(a=instruction[2], b=instruction[1], out=check2);
        And(a=check2, b=greater1, out=MustLesserEqual); // Jump if <0 or =0 - 110

        Not(in= instruction[1], out= equal1);
        And(a=instruction[0], b=instruction[2], out=check3);
        And(a=check3, b=equal1, out=MustNotEqual); // Jump if <0 or >0 - 101

        Not(in= instruction[2], out= not2);
        Not(in= instruction[1], out= not1);
        And(a=not2, b=not1, out=Andx);        
        And(a=Andx, b=instruction[0], out=MustGreater); // Jump if >0 - 001

        Not(in= instruction[2], out= not3);
        Not(in= instruction[0], out= not4);
        And(a=not3, b=not4, out=Andy);        
        And(a=Andy, b=instruction[1], out=MustEqual); // Jump if =0 - 010

        Not(in= instruction[0], out= not5);
        Not(in= instruction[1], out= not6);
        And(a=not5, b=not6, out=Andz);        
        And(a=Andz, b=instruction[2], out=MustLesser); // Jump if <0 - 100
        
        // Or condition met
        Not(in=Zero, out=NotZero);
        Not(in=Negative, out=NotNegative);
        And(a=NotZero, b=NotNegative, out=Greater);
        Not(in=Greater, out=NotGreater);

        Or(a=Greater, b=Zero, out=GreaterOrZero); //greater or zero
        Or(a=Negative, b=Zero, out=LesserOrZero); //lesser or zero
        Or(a=Greater, b=Negative, out=GreaterOrLesser); //greater or lesser

        // Multiplexers
        Mux(a= true, b= GreaterOrZero, sel= MustGreaterEqual, out=Mux1);
        Mux(a= true, b= LesserOrZero, sel= MustLesserEqual, out=Mux2);
        Mux(a= true, b= GreaterOrLesser, sel= MustNotEqual, out=Mux3);
        Mux(a= true, b= Greater, sel= MustGreater, out=Mux4);
        Mux(a= true, b= Zero, sel= MustEqual, out=Mux5);
        Mux(a= true, b= Negative, sel= MustLesser, out=Mux6);

        // Check 000

        Not(in=instruction[0], out=j0);
        Not(in=instruction[1], out=j1);
        Not(in=instruction[2], out=j2);

        And(a=j0, b=j1, out=oneCheck);
        And(a=oneCheck, b=j2, out=NoJump); // 000

        //Ands
        And(a= Mux1, b= Mux2, out= And1);
        And(a= Mux3, b= Mux4, out= And2);
        And(a= Mux5, b= Mux6, out= And3);

        And(a= And1, b= And2, out= And4);
        And(a= And4, b=And3, out=PrePC);

        Not(in=PrePC, out=NotPrePC);
        Mux(a=PrePC, b=NotPrePC, sel=NoJump, out=FinalPrePC); 
        
        And(a=instruction[15], b=FinalPrePC, out=PCLoad);

        // Program Counter
        PC(in= ARegisterOut, load= PCLoad, inc=true, reset= reset, out[0..14]= pc);
}