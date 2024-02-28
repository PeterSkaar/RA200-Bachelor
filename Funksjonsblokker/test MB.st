
VAR_INPUT
	X: BOOL;
	XF: BOOL;
	RX: BOOL;
	FB: BOOL;
	FU: BOOL;
END_VAR

VAR_OUTPUT
	Y: BOOL;
	YF: BOOL;
	BB: BOOL;
	BU: BOOL;
	BX: BOOL;
END_VAR

VAR_STAT
    Invert: BOOL;
    Latched: BOOL;
    // delay

    sbX : BOOL;
END_VAR

VAR
	tbX: BOOL;
	tbXF: BOOL;
	tbRX: BOOL;
	tbFB: BOOL;
	tbFU: BOOL;

    internal_error: BOOL;
END_VAR

// INPUTS

// 1) X Binary input Normal FUNCTION input Binary input signal FROM process.
// 2) XF Binary input External fault Fault indication from outside the template.
// 3) RX Binary input Reset latched output Resets the output Y when RX goes high.
// 4) FB Binary input Force blocking If FB is true, Y is set to 0.
// 5) FU Binary input Force suppression. If FU is true, Y is set to 0, YF is set to 0 and OS alarm is set to 0.

// OUTPUTS

// 1) Y Binary output Normal FUNCTION output IF the template is set NOT TO latch, Y = X
//		IF the template is set TO latch, Y is set when X goes high, AND
//		reset when RX goes high.
//		Subjected to blocking and suppression.
//		It shall be possible to generate a warning or action alarm on
//		this output. In these cases the letter W (warning) or A
//		(action) shall be used as the terminal name on the SCD
//		diagram.
// 2) YF Binary output Function failed YF = 1 if XF = 1 or if an internal error has been detected in the template.
//		Subjected to suppression.
// 3) BB Binary output Status blocked True if the template is in blocked mode (FB = 1 or Blocking set from OS).
// 4) BU Binary output Status suppressed True if template is in suppress mode (FU = 1 or Suppression sett from OS).
// 5) BX Binary output Status function input BX = X

// Populate/Initialize temporaries

// Handle/Validate inputs

// Do <Whatever the program should do>

// Write to outputs

// [Handle transfer of data to HMI systems (if applicable)]


tbx 	:= X;
tbXF 	:= XF;
tbRX 	:= RX;
tbFB 	:= FB;
tbFU 	:= FU;

// Handle parameter inverted
IF Invert THEN
    tbx := NOT tbx;
END_IF;


// Mode Not latched
IF Latched := FALSE THEN

    // Handle Force Supression
    IF FU THEN
        BU := TRUE;
        Y := FALSE;
        YF := FALSE;
        // OS status
    ELSE
        BU := FALSE;
    END_IF;
    
    // Handle Force block
    IF FB THEN
        BB := TRUE;
        Y := FALSE;
    ELSE
        ;
    END_IF;


    // Handle Fault
    IF (tbXF or internal_error) and not FU THEN
        YF := TRUE;
    ELSE
        YF := FALSE;
    END_IF;

    // Output subject to blocking and supression
    IF FB or FU THEN
        Y := FALSE;
    ELSE
        Y := tbx;
    END_IF;
    

    BX := tbX;

END_IF


IF Latched := TRUE THEN
    
    // Handle Force Supression
    IF FU THEN
        BU := TRUE;
        Y := FALSE;
        YF := FALSE;
        // OS status
    ELSE
        BU := FALSE;
    END_IF;

    // Handle Force block
    IF FB THEN
        BB := TRUE;
        Y := FALSE;
    END_IF;

    // Handle Fault
    IF (tbXF or internal_error) and not FU THEN
        YF := TRUE;
    ELSE
        YF := FALSE;
    END_IF;

    // Posetiv edge on Y
    IF tbX and not sbX THEN
        Y := tbx;
    END_IF;
    
    IF tbRX THEN
        Y := False;
    END_IF;
    

    // BX always equal to input X
    BX := tbX;

    // Reset posetiv edge
    sbx := tbX;
END_IF;





















