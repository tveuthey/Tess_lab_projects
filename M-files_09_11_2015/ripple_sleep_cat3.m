function [hold_s1d_tpre, ripl_pre, hold_s1d_tpost, ripl_post, change]=ripple_sleep_cat3(units,lim,TimeStamps,sleep_ind_pre,sleep_ind_post,data, Fs_lfp, chan_no,sc, freq)
close all

if isempty(chan_no)==1
        nch = 1;
else nch=0;
end
    
for i=1:length(units)
    close;
    unit=units(i);
    
    lim1=lim(1);
    lim2=lim(2);
    lim3=lim(3);
    
    if nch==1
        if unit==1
            chan_no=[3];
        else
            if unit==2
                chan_no=[4];
            else
                if unit==3
                    chan_no=[6];
                else if unit==4
                        chan_no=[6];
                    else if unit==5
                            chan_no=[7];
                        else if unit==6
                                chan_no=[8];
                            else if unit==7
                                    chan_no=[2];
                                else if unit==8
                                        chan_no=[15];
                                    else if unit==9
                                            chan_no=[11];
                                        else if unit==10
                                                chan_no=[12];
                                            else if unit==11
                                                    chan_no=[13];
                                                else if unit==12
                                                        chan_no=[14];
                                                    else if unit==13
                                                            chan_no=[15];
                                                        else if unit==14
                                                                chan_no=[16];
                                                            else if unit==15
                                                                    chan_no=[31];
                                                                else if unit==16
                                                                        chan_no=[9];
                                                                    else if unit==17
                                                                            chan_no=[19];
                                                                        else if unit==18
                                                                                chan_no=[20];
                                                                            else if unit==19
                                                                                    chan_no=[21];
                                                                                else if unit==20
                                                                                        chan_no=[22];
                                                                                    else if unit==21
                                                                                            chan_no=[23];
                                                                                        else if unit==22
                                                                                                chan_no=[24];
                                                                                            else if unit==23
                                                                                                    chan_no=[21];
                                                                                                else if unit==24
                                                                                                        chan_no=[31];
                                                                                                    else if unit==25
                                                                                                            chan_no=[27];
                                                                                                        else if unit==26
                                                                                                                chan_no=[28];
                                                                                                            else if unit==27
                                                                                                                    chan_no=[29];
                                                                                                                else if unit==28
                                                                                                                        chan_no=[30];
                                                                                                                    else if unit==29
                                                                                                                            chan_no=[31];
                                                                                                                        else if unit==30
                                                                                                                                chan_no=[32];
                                                                                                                            else if unit==31
                                                                                                                                    chan_no=[15];
                                                                                                                                else if unit==32
                                                                                                                                        chan_no=[25];
                                                                                                                                    end
                                                                          ' = =     ��R�           ����    ����p                                                               �y      M       s�LM�6����P��G5                x                              8      �                              @      �                                                                                                                                                                                            h  �  �                                                                            P'                                                                                                                                                                                                                                                                                                                                                                                                                        p  (                                                                                                '                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              '                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              '                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              '                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              '                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              '                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              '                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              '                                                                                                                                                                                                                                                                                                                                                                                                                        @        C   ���0   �@�                   �  h          ����       @�                        '                    ����                 ,          ����    ����                                \ D e v i c e \ H a r d d i s k V o l u m e 2 8 6 \ $ E x t e n d \ $ R m M e t a d a t a \ $ T x f L o g \ $ T x f L o g . b l f       ���0   7���                   0  �          ����                                                      ���� (       (       ,       *       (                                      T x f L o g     ���0   1�J	`                   �  p          ���0     �             �	��'              % B L F % \ $ T x f L o g C o n t a i n e r 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1     ���0   2�J	`                   X  (          ���0     �           0�����              % B L F % \ $ T x f L o g C o n t a i n e r 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2     ���0   7!	�                   h  �          ����                                                      ����                                                                       K t m L o g                           '                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              '                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              '                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              '                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              '                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              '                                                                                                                                                                                                                                                                                                    