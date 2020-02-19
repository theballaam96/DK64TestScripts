function defineMipsLibrary(param1,param2,param3) {
	mips_library = {
		add: {
			format: [[0,6],[param2,5],[param3,5],[param1,5],[32,11]],
		},
		addi: {
			format: [[8,6],[param2,5],[param1,5],[param3,16]],
		},
		addiu: {
			format: [[9,6],[param2,5],[param1,5],[param3,16]],
		},
		addu: {
			format: [[0,6],[param2,5],[param3,5],[param1,5],[33,11]],
		},
		and: {
			format: [[0,6],[param2,5],[param3,5],[param1,5],[36,11]],
		},
		andi: {
			format: [[12,6],[param2,5],[param1,5],[param3,16]],
		},
		beq: {
			format: [[4,6],[param1,5],[param2,5],[param3,16]],
		},
		beql: {
			format: [[20,6],[param1,5],[param2,5],[param3,16]],
		},
		bgez: {
			format: [[1,6],[param1,5],[1,5],[param2,16]],
		},
		bgezal: {
			format: [[1,6],[param1,5],[17,5],[param2,16]],
		},
		bgezall: {
			format: [[1,6],[param1,5],[19,5],[param2,16]],
		},
		bgezl: {
			format: [[1,6],[param1,5],[3,5],[param2,16]],
		},
		bgtz: {
			format: [[7,6],[param1,5],[0,5],[param2,16]],
		},
		bgtzl: {
			format: [[23,6],[param1,5],[0,5],[param2,16]],
		},
		blez: {
			format: [[6,6],[param1,5],[0,5],[param2,16]],
		},
		blezl: {
			format: [[22,6],[param1,5],[0,5],[param2,16]],
		},
		bltz: {
			format: [[1,6],[param1,5],[0,5],[param2,16]],
		},
		bltzal: {
			format: [[1,6],[param1,5],[16,5],[param2,16]],
		},
		bltzall: {
			format: [[1,6],[param1,5],[18,5],[param2,16]],
		},
		bltzl: {
			format: [[1,6],[param1,5],[2,5],[param2,16]],
		},
		bne: {
			format: [[5,6],[param1,5],[param2,5],[param3,16]],
		},
		bnel: {
			format: [[21,6],[param1,5],[param2,5],[param3,16]],
		},
		// break: {
		// 	format: [[0,6],[param1,20],[13,6]],
		// },
		// copz: {
		// 	format: [["0100zz",6],[param1,26]],
		// },
		dadd: {
			format: [[0,6],[param2,5],[param3,5],[param1,5],[44,11]],
		},
		daddi: {
			format: [[24,6],[param2,5],[param1,5],[param3,16]],
		},
		daddiu: {
			format: [[25,6],[param2,5],[param1,5],[param3,16]],
		},
		daddu: {
			format: [[0,6],[param2,5],[param3,5],[param1,5],[45,11]],
		},
		ddiv: {
			format: [[0,6],[param1,5],[param2,5],[30,16]],
		},
		ddivu: {
			format: [[0,6],[param1,5],[param2,5],[31,16]],
		},
		div: {
			format: [[0,6],[param1,5],[param2,5],[26,16]],
		},
		divu: {
			format: [[0,6],[param1,5],[param2,5],[27,16]],
		},
		dmult: {
			format: [[0,6],[param1,5],[param2,5],[28,16]],
		},
		dmultu: {
			format: [[0,6],[param1,5],[param2,5],[29,16]],
		},
		dsll: {
			format: [[0,11],[param2,5],[param1,5],[param3,5],[56,6]],
		},
		dsll32: {
			format: [[0,11],[param2,5],[param1,5],[param3,5],[60,6]],
		},
		dsllv: {
			format: [[0,6],[param3,5],[param2,5],[param3,5],[20,11]],
		},
		dsra: {
			format: [[0,11],[param2,5],[param1,5],[param3,5],[59,6]],
		},
		dsra32: {
			format: [[0,11],[param2,5],[param1,5],[param3,5],[63,6]],
		},
		dsrav: {
			format: [[0,6],[param3,5],[param2,5],[param3,5],[23,11]],
		},
		dsrl: {
			format: [[0,11],[param2,5],[param1,5],[param3,5],[58,6]],
		},
		dsrl32: {
			format: [[0,11],[param2,5],[param1,5],[param3,5],[62,6]],
		},
		dsrlv: {
			format: [[0,6],[param3,5],[param2,5],[param1,5],[22,11]],
		},
		dsub: {
			format: [[0,6],[param2,5],[param3,5],[param1,5],[46,11]],
		},
		dsubu: {
			format: [[0,6],[param2,5],[param3,5],[param1,5],[47,11]],
		},
		j: {
			format: [[2,6],[param1,26]],
		},
		jal: {
			format: [[3,6],[param1,26]],
		},
		jalr: {
			format: [[0,6],[param2,5],[0,5],[param1,5],[9,11]],
		},
		jr: {
			format: [[0,6],[param1,5],[8,21]],
		},
		lb: {
			format: [[32,6],[param3,5],[param1,5],[param2,16]],
		},
		lbu: {
			format: [[36,6],[param3,5],[param1,5],[param2,16]],
		},
		ld: {
			format: [[55,6],[param3,5],[param1,5],[param2,16]],
		},
		// ldcz: {
		// 	format: [["1101zz",6],[param3,5],[param1,5],[param2,16]],
		// },
		ldl: {
			format: [[26,6],[param3,5],[param1,5],[param2,16]],
		},
		ldr: {
			format: [[27,6],[param3,5],[param1,5],[param2,16]],
		},
		lh: {
			format: [[33,6],[param3,5],[param1,5],[param2,16]],
		},
		lhu: {
			format: [[37,6],[param3,5],[param1,5],[param2,16]],
		},
		ll: {
			format: [[48,6],[param3,5],[param1,5],[param2,16]],
		},
		lld: {
			format: [[52,6],[param3,5],[param1,5],[param2,16]],
		},
		lui: {
			format: [[480,11],[param1,5],[param2,16]],
		},
		lw: {
			format: [[35,6],[param3,5],[param1,5],[param2,16]],
		},
		// lwcz: {
		// 	format: [["1100zz",6],[param3,5],[param1,5],[param2,16]],
		// },
		lwl: {
			format: [[34,6],[param3,5],[param1,5],[param2,16]],
		},
		lwr: {
			format: [[38,6],[param3,5],[param1,5],[param2,16]],
		},
		lwu: {
			format: [[39,6],[param3,5],[param1,5],[param2,16]],
		},
		mfhi: {
			format: [[0,16],[param1,5],[16,11]],
		},
		mflo: {
			format: [[0,16],[param1,5],[18,11]],
		},
		movn: {
			format: [[0,6],[param2,5],[param3,5],[param1,5],[11,11]],
		},
		movz: {
			format: [[0,6],[param2,5],[param3,5],[param1,5],[10,11]],
		},
		mthi: {
			format: [[0,6],[param1,5],[17,21]],
		},
		mthi: {
			format: [[0,6],[param1,5],[19,21]],
		},
		mult: {
			format: [[0,6],[param1,5],[param2,5],[24,16]],
		},
		multu: {
			format: [[0,6],[param1,5],[param2,5],[25,16]],
		},
		nor: {
			format: [[0,6],[param2,5],[param3,5],[param1,5],[39,11]],
		},
		or: {
			format: [[0,6],[param2,5],[param3,5],[param1,5],[37,11]],
		},
		ori: {
			format: [[13,6],[param2,5],[param1,5],[param3,16]],
		},
		pref: {
			format: [[27,6],[param3,5],[param1,5],[param2,16]],
		},
		sb: {
			format: [[40,6],[param3,5],[param1,5],[param2,16]],
		},
		sc: {
			format: [[56,6],[param3,5],[param1,5],[param2,16]],
		},
		scd: {
			format: [[60,6],[param3,5],[param1,5],[param2,16]],
		},
		sd: {
			format: [[63,6],[param3,5],[param1,5],[param2,16]],
		},
		// sdcz: {
		// 	format: [["1111zz",6],[param3,5],[param1,5],[param2,16]],
		// },
		sdl: {
			format: [[44,6],[param3,5],[param1,5],[param2,16]],
		},
		sdr: {
			format: [[45,6],[param3,5],[param1,5],[param2,16]],
		},
		sh: {
			format: [[41,6],[param3,5],[param1,5],[param2,16]],
		},
		sll: {
			format: [[0,11],[param2,5],[param1,5],[param3,5],[0,6]],
		},
		sllv: {
			format: [[0,6],[param3,5],[param2,5],[param1,5],[4,11]],
		},
		slt: {
			format: [[0,6],[param2,5],[param3,5],[param1,5],[42,11]],
		},
		slti: {
			format: [[10,6],[param2,5],[param1,5],[param3,16]],
		},
		sltiu: {
			format: [[11,6],[param2,5],[param1,5],[param3,16]],
		},
		sltu: {
			format: [[0,6],[param2,5],[param3,5],[param1,5],[43,11]],
		},
		sra: {
			format: [[0,11],[param2,5],[param1,5],[param3,5],[3,6]],
		},
		srav: {
			format: [[0,6],[param3,5],[param2,5],[param1,5],[7,11]],
		},
		srl: {
			format: [[0,11],[param2,5],[param1,5],[param3,5],[2,6]],
		},
		srlv: {
			format: [[0,6],[param3,5],[param2,5],[param1,5],[6,11]],
		},
		sub: {
			format: [[0,6],[param2,5],[param3,5],[param1,5],[34,11]],
		},
		subu: {
			format: [[0,6],[param2,5],[param3,5],[param1,5],[35,11]],
		},
		sw: {
			format: [[43,6],[param3,5],[param1,5],[param2,16]],
		},
		// swcz: {
		// 	format: [["1110zz",6],[param3,5],[param1,5],[param2,16]],
		// },
		swl: {
			format: [[42,6],[param3,5],[param1,5],[param2,16]],
		},
		swr: {
			format: [[46,6],[param3,5],[param1,5],[param2,16]],
		},
		sync: {
			format: [[0,21],[param1,5],[15,6]],
		},
		// syscall: {
		// 	format: [[0,6],[param1,20],["001100",6]],
		// },
		// teq: {
		// 	format: [[0,6],[param1,5],[param2,5],[param3,10],[52,6]],
		// },
		teqi: {
			format: [[1,6],[param1,5],[12,5],[param2,16]],
		},
		// tge: {
		// 	format: [[0,6],[param1,5],[param2,5],[param3,10],[48,6]],
		// },
		tgei: {
			format: [[1,6],[param1,5],[8,5],[param2,16]],
		},
		tgeiu: {
			format: [[1,6],[param1,5],[9,5],[param2,16]],
		},
		// tgeu: {
		// 	format: [[0,6],[param1,5],[param2,5],[param3,10],["110001",6]],
		// },
		// tlt: {
		// 	format: [[0,6],[param1,5],[param2,5],[param3,10],["110010",6]],
		// },
		tlti: {
			format: [[1,6],[param1,5],[10,5],[param2,16]],
		},
		tltiu: {
			format: [[1,6],[param1,5],[11,5],[param2,16]],
		},
		// tlt: {
		// 	format: [[0,6],[param1,5],[param2,5],[param3,10],[27,6]],
		// },
		// tne: {
		// 	format: [[0,6],[param1,5],[param2,5],[param3,10],["110110",6]],
		// },
		tnei: {
			format: [[1,6],[param1,5],[14,5],[param2,16]],
		},
		xor: {
			format: [[0,6],[param2,5],[param3,5],[param1,5],[38,11]],
		},
		xori: {
			format: [[14,6],[param2,5],[param1,5],[param3,16]],
		}
	}
	return mips_library;
}

n64_registers = {
	$zero: 0,
	$at: 1,
	$v0: 2,
	$v1: 3,
	$a0: 4,
	$a1: 5,
	$a2: 6,
	$a3: 7,
	$t0: 8,
	$t1: 9,
	$t2: 10,
	$t3: 11,
	$t4: 12,
	$t5: 13,
	$t6: 14,
	$t7: 15,
	$s0: 16,
	$s1: 17,
	$s2: 18,
	$s3: 19,
	$s4: 20,
	$s5: 21,
	$s6: 22,
	$s7: 23,
	$t8: 24,
	$t9: 25,
	$k0: 26,
	$k1: 27,
	$gp: 28,
	$sp: 29,
	$fp: 30,
	$ra: 31
}

function convertParameterToDecimal(parameter) {
	register_keys =  Object.keys(n64_registers);
	if (register_keys.indexOf(parameter) > -1) {
		return n64_registers[parameter];
	} else {
		return parseInt(parameter);
	}
}

function snipEnd(value,snip_length,white_space) {
	output_string = "";
	for (j = 0; j < snip_length; j++) {
		output_string += white_space;
	}
	output_string += value
	output_string = output_string.substring(output_string.length - snip_length, output_string.length);
	return output_string;
}

gameshark_list = [];

function convertLine(input_line) {
	// Lines are of the format 0xADDRES FUNC Param1 Param2 (...)
	// Eg. 0x400004 LUI $s3 0x800C
	const mips_line = input_line.trim();
	const split_line = mips_line.split(" ");
	const address = split_line[0];
	const mips_func = split_line[1].toLowerCase();
	var params = [];
	for (i = 0; i < 3; i++) {
		params[i] = 0;
	}
	for (i = 2; i < split_line.length; i++) {
		raw_parameter = split_line[i];
		params[i - 2] = convertParameterToDecimal(raw_parameter);
	}
	mips_library = defineMipsLibrary(params[0],params[1],params[2]);
	mips_hex = 0;
	sum_of_powers = 0;
	for (i = 0; i < mips_library[mips_func].format.length; i++) {
		format_definition = mips_library[mips_func].format
		index = format_definition.length - i - 1;
		value = format_definition[index][0] % (Math.pow(2,format_definition[index][1]))
		mips_hex += (value * Math.pow(2,sum_of_powers))
		sum_of_powers += format_definition[index][1]
	}
	mips_hex = snipEnd(mips_hex.toString(16).toUpperCase(),8,"0");
	address_1 = snipEnd(parseInt(address).toString(16),6,"0");
	address_2 = snipEnd((parseInt(address) + 2).toString(16),6,"0");
	gameshark_1 = "81" + address_1 + " " + mips_hex.substring(0,4);
	gameshark_2 = "81" + address_2 + " " + mips_hex.substring(4,8);
	gameshark_list.push(gameshark_1)
	gameshark_list.push(gameshark_2)
}

	// 0x400004 LUI $s3 0x800C
	// 0x400008 LBU $s0 0x68D9 $s3
	// 0x40000C ADDIU $s4 $zero 0x001D
	// 0x400010 BNE $s4 $s0 0x0010
	// 0x400014 [nop]
	// 0x400018 LBU $s0 0x6B03 $s3
	// 0x40001C ADDIU $s4 $zero 0x0014
	// 0x400020 BNE $s4 $s0 0x000C
	// 0x400024 [nop]
	// 0x400028 LBU $s0 0x68DB $s3
	// 0x40002C ADDIU $s4 $zero 0x0009
	// 0x400030 BEQ $s4 $s0 0x0008
	// 0x400034 [nop]
	// 0x400038 LUI $s3 0x8040
	// 0x40003C LW $s0 0x0000 $s3
	// 0x400040 BEQ $zero $s0 0x0004
	// 0x400044 [nop]
	// 0x400048 LUI $s3 0x800C
	// 0x40004C SW $s0 0x6844 $s3
	// 0x400050 [x][nop]
	// 0x400054 LUI $s3 0x800C
	// 0x400058 LW $s0 0x6844 $s3
	// 0x40005C LUI $s3 0x8040
	// 0x400060 SW $s0 0x0000 $s3
	// 0x400064 [nop]
	// 0x400068 LUI $s3 0x800C
	// 0x40006C LBU $s0 0x68D9 $s3
	// 0x400070 ADDIU $s4 $zero 0x0006
	// 0x400074 BNE $s4 $s0 0x0008
	// 0x400078 [nop]
	// 0x40007C LBU $s0 0x6B03 $s3
	// 0x400080 ADDIU $s4 $zero 0x000C
	// 0x400084 BNE $s4 $s0 0x0004
	// 0x400088 [nop]
	// 0x40008C ADDIU $s4 $zero 0x0001
	// 0x400090 SB $s4 0x6C64 $s3
	// 0x400094 [y][nop]
	// 0x400098 original function - 08026DFE

convertLine("0x400004 LUI $s3 0x800C")
console.log(gameshark_list)
// console.log(convertParameterToDecimal("$s4"))