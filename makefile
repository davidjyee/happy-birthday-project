# Created by the Intel FPGA Monitor Program
# DO NOT MODIFY

############################################
# Global Defines
DEFINE_COMMA	:= ,

############################################
# Compilation Targets

# Programs
AS		:= arm-altera-eabi-as
CC		:= arm-altera-eabi-gcc
LD		:= arm-altera-eabi-ld
OC		:= arm-altera-eabi-objcopy
RM		:= rm -f

# Flags
USERCCFLAGS	:= -g -O3 -std=c11
ARCHASFLAGS	:= -mfloat-abi=soft -march=armv7-a -mcpu=cortex-a9 --gstabs -I "$$GNU_ARM_TOOL_ROOTDIR/arm-altera-eabi/include/"
ARCHCCFLAGS	:= -mfloat-abi=soft -march=armv7-a -mtune=cortex-a9 -mcpu=cortex-a9
ARCHLDFLAGS	:= --defsym arm_program_mem=0x40 --defsym arm_available_mem_size=0x3fffffb8 --defsym __cs3_stack=0x3ffffff8 --section-start .vectors=0x0
ARCHLDSCRIPT	:= -T"C:/intelFPGA_lite/18.0/University_Program/Monitor_Program/build/altera-socfpga-hosted-with-vectors.ld"
ASFLAGS		:= $(ARCHASFLAGS)
CCFLAGS		:= -Wall -c $(USERCCFLAGS) $(ARCHCCFLAGS)
LDFLAGS		:= $(patsubst %, -Wl$(DEFINE_COMMA)%, $(ARCHLDFLAGS)) $(ARCHLDSCRIPT)
OCFLAGS		:= -O srec

# Files
HDRS		:=
SRCS		:= project_main.c config_A9_interrupts.c exceptions.c music.c audio_stream.c
OBJS		:= $(patsubst %, %.o, $(SRCS))

# Targets
compile: project_main.srec

project_main.srec: project_main.axf
	$(RM) $@
	$(OC) $(OCFLAGS) $< $@

project_main.axf: $(OBJS)
	$(RM) $@
	$(CC) $(LDFLAGS) $(OBJS) -lm -o $@

%.c.o: %.c $(HDRS)
	$(RM) $@
	$(CC) $(CCFLAGS) $< -o $@

%.s.o: %.s $(HDRS)
	$(RM) $@
	$(AS) $(ASFLAGS) $< -o $@

clean:
	$(RM) project_main.srec project_main.axf $(OBJS)

