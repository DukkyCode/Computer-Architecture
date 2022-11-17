library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- to_integer and unsigned

entity DMEM is
-- The data memory is a byte addressble, little-endian, read/write memory with a single address port
-- It may not read and write at the same time
generic(NUM_BYTES : integer := 1024);
-- NUM_BYTES is the number of bytes in the memory (small to save computation resources)
port(
     WriteData          : in  STD_LOGIC_VECTOR(63 downto 0); -- Input data
     Address            : in  STD_LOGIC_VECTOR(63 downto 0); -- Read/Write address
     MemRead            : in  STD_LOGIC; -- Indicates a read operation
     MemWrite           : in  STD_LOGIC; -- Indicates a write operation
     Clock              : in  STD_LOGIC; -- Writes are triggered by a rising edge
     ReadData           : out STD_LOGIC_VECTOR(63 downto 0); -- Output data
     --Probe ports used for testing
     DEBUG_MEM_CONTENTS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
);
end DMEM;

architecture behavioral of DMEM is
type ByteArray is array (0 to NUM_BYTES) of STD_LOGIC_VECTOR(7 downto 0); 
signal dmemBytes:ByteArray;
begin
   process(Clock,MemRead,MemWrite,WriteData,Address) -- Run when any of these inputs change
   variable addr:integer;
   variable first:boolean := true; -- Used for initialization
   begin
      -- This part of the process initializes the memory and is only here for simulation purposes
      -- It does not correspond with actual hardware!
      if(first) then
         -- Example: MEM(0x0) = 0x0000000000000010 (Hex) 
         --  1(decimal)
         dmemBytes(7)  <= "00000000";
         dmemBytes(6)  <= "00000000";  
         dmemBytes(5)  <= "00000000";  
         dmemBytes(4)  <= "00000000";  
         dmemBytes(3)  <= "00000000";
         dmemBytes(2)  <= "00000000";  
         dmemBytes(1)  <= "00000000";  
         dmemBytes(0)  <= "00010001";  --least significant has the lowest address

         dmemBytes(15) <= "00000000";
         dmemBytes(14) <= "00000000";  
         dmemBytes(13) <= "00000000";  
         dmemBytes(12) <= "00000000";  
         dmemBytes(11) <= "00000000";
         dmemBytes(10) <= "00000000";  
         dmemBytes(9)  <= "00000000";  
         dmemBytes(8)  <= "00010001";  

         dmemBytes(23)  <= "00000000";
         dmemBytes(22)  <= "00000000";  
         dmemBytes(21)  <= "00000000";  
         dmemBytes(20)  <= "00000000";  
         dmemBytes(19)  <= "00000000";
         dmemBytes(18)  <= "00000000";  
         dmemBytes(17)  <= "00000000";  
         dmemBytes(16)  <= "00010001";  

         dmemBytes(31)  <= "00000000";
         dmemBytes(30)  <= "00000000";  
         dmemBytes(29)  <= "00000000";  
         dmemBytes(28)  <= "00000000";  
         dmemBytes(27)  <= "00000000";
         dmemBytes(26)  <= "00000000";  
         dmemBytes(25)  <= "00000000";  
         dmemBytes(24)  <= "00010001";  
         
         dmemBytes(39)  <= "00000000";
         dmemBytes(38)  <= "00000000";  
         dmemBytes(37)  <= "00000000";  
         dmemBytes(36)  <= "00000000";
         dmemBytes(35)  <= "00000000";
         dmemBytes(34)  <= "00000000";  
         dmemBytes(33)  <= "00000000";  
         dmemBytes(32)  <= "00000000"; 

         dmemBytes(47)  <= "00000000";
         dmemBytes(46)  <= "00000000";  
         dmemBytes(45)  <= "00000000";  
         dmemBytes(44)  <= "00000000";         
         dmemBytes(43)  <= "00000000";
         dmemBytes(42)  <= "00000000";  
         dmemBytes(41)  <= "00000001";  
         dmemBytes(40)  <= "00000000";  

         dmemBytes(55)  <= "00000000";
         dmemBytes(54)  <= "00000000";  
         dmemBytes(53)  <= "00000000";  
         dmemBytes(52)  <= "00000000";           
         dmemBytes(51)  <= "00000000";
         dmemBytes(50)  <= "00000000";  
         dmemBytes(49)  <= "00000000";  
         dmemBytes(48)  <= "00000000";

         dmemBytes(63)  <= "00000000";
         dmemBytes(62)  <= "00000000";  
         dmemBytes(61)  <= "00000000";  
         dmemBytes(60)  <= "00000000";           
         dmemBytes(59)  <= "00000000";
         dmemBytes(58)  <= "00000000";  
         dmemBytes(57)  <= "00000000";  
         dmemBytes(56)  <= "00000000";
         
         --Added Memory Contents
         dmemBytes(71) <= "00000000";
         dmemBytes(70) <= "00000000";
         dmemBytes(69) <= "00000000";
         dmemBytes(68) <= "00000000";
         dmemBytes(67) <= "00000000";
         dmemBytes(66) <= "00000000";
         dmemBytes(65) <= "00000000";
         dmemBytes(64) <= "00000000";
         
         dmemBytes(79) <= "00000000";
         dmemBytes(78) <= "00000000";
         dmemBytes(77) <= "00000000";
         dmemBytes(76) <= "00000000";
         dmemBytes(75) <= "00000000";
         dmemBytes(74) <= "00000000";
         dmemBytes(73) <= "00000000";
         dmemBytes(72) <= "00000000";
         
         dmemBytes(87) <= "00000000";
         dmemBytes(86) <= "00000000";
         dmemBytes(85) <= "00000000";
         dmemBytes(84) <= "00000000";
         dmemBytes(83) <= "00000000";
         dmemBytes(82) <= "00000000";
         dmemBytes(81) <= "00000000";
         dmemBytes(80) <= "00000000";
         
         dmemBytes(95) <= "00000000";
         dmemBytes(94) <= "00000000";
         dmemBytes(93) <= "00000000";
         dmemBytes(92) <= "00000000";
         dmemBytes(91) <= "00000000";
         dmemBytes(90) <= "00000000";
         dmemBytes(89) <= "00000000";
         dmemBytes(88) <= "00000000";
         
         dmemBytes(103) <= "00000000";
         dmemBytes(102) <= "00000000";
         dmemBytes(101) <= "00000000";
         dmemBytes(100) <= "00000000";
         dmemBytes(99) <= "00000000";
         dmemBytes(98) <= "00000000";
         dmemBytes(97) <= "00000000";
         dmemBytes(96) <= "00000000";
         
         dmemBytes(111) <= "00000000";
         dmemBytes(110) <= "00000000";
         dmemBytes(109) <= "00000000";
         dmemBytes(108) <= "00000000";
         dmemBytes(107) <= "00000000";
         dmemBytes(106) <= "00000000";
         dmemBytes(105) <= "00000000";
         dmemBytes(104) <= "00000000";
         
         dmemBytes(119) <= "00000000";
         dmemBytes(118) <= "00000000";
         dmemBytes(117) <= "00000000";
         dmemBytes(116) <= "00000000";
         dmemBytes(115) <= "00000000";
         dmemBytes(114) <= "00000000";
         dmemBytes(113) <= "00000000";
         dmemBytes(112) <= "00000000";
         
         dmemBytes(127) <= "00000000";
         dmemBytes(126) <= "00000000";
         dmemBytes(125) <= "00000000";
         dmemBytes(124) <= "00000000";
         dmemBytes(123) <= "00000000";
         dmemBytes(122) <= "00000000";
         dmemBytes(121) <= "00000000";
         dmemBytes(120) <= "00000000";
         
         dmemBytes(135) <= "00000000";
         dmemBytes(134) <= "00000000";
         dmemBytes(133) <= "00000000";
         dmemBytes(132) <= "00000000";
         dmemBytes(131) <= "00000000";
         dmemBytes(130) <= "00000000";
         dmemBytes(129) <= "00000000";
         dmemBytes(128) <= "00000000";
         
         dmemBytes(143) <= "00000000";
         dmemBytes(142) <= "00000000";
         dmemBytes(141) <= "00000000";
         dmemBytes(140) <= "00000000";
         dmemBytes(139) <= "00000000";
         dmemBytes(138) <= "00000000";
         dmemBytes(137) <= "00000000";
         dmemBytes(136) <= "00000000";
         
         dmemBytes(151) <= "00000000";
         dmemBytes(150) <= "00000000";
         dmemBytes(149) <= "00000000";
         dmemBytes(148) <= "00000000";
         dmemBytes(147) <= "00000000";
         dmemBytes(146) <= "00000000";
         dmemBytes(145) <= "00000000";
         dmemBytes(144) <= "00000000";
         
         dmemBytes(159) <= "00000000";
         dmemBytes(158) <= "00000000";
         dmemBytes(157) <= "00000000";
         dmemBytes(156) <= "00000000";
         dmemBytes(155) <= "00000000";
         dmemBytes(154) <= "00000000";
         dmemBytes(153) <= "00000000";
         dmemBytes(152) <= "00000000";
         
         dmemBytes(167) <= "00000000";
         dmemBytes(166) <= "00000000";
         dmemBytes(165) <= "00000000";
         dmemBytes(164) <= "00000000";
         dmemBytes(163) <= "00000000";
         dmemBytes(162) <= "00000000";
         dmemBytes(161) <= "00000000";
         dmemBytes(160) <= "00000000";
         
         dmemBytes(175) <= "00000000";
         dmemBytes(174) <= "00000000";
         dmemBytes(173) <= "00000000";
         dmemBytes(172) <= "00000000";
         dmemBytes(171) <= "00000000";
         dmemBytes(170) <= "00000000";
         dmemBytes(169) <= "00000000";
         dmemBytes(168) <= "00000000";
         
         dmemBytes(183) <= "00000000";
         dmemBytes(182) <= "00000000";
         dmemBytes(181) <= "00000000";
         dmemBytes(180) <= "00000000";
         dmemBytes(179) <= "00000000";
         dmemBytes(178) <= "00000000";
         dmemBytes(177) <= "00000000";
         dmemBytes(176) <= "00000000";
         
         dmemBytes(191) <= "00000000";
         dmemBytes(190) <= "00000000";
         dmemBytes(189) <= "00000000";
         dmemBytes(188) <= "00000000";
         dmemBytes(187) <= "00000000";
         dmemBytes(186) <= "00000000";
         dmemBytes(185) <= "00000000";
         dmemBytes(184) <= "00000000";
         
         dmemBytes(199) <= "00000000";
         dmemBytes(198) <= "00000000";
         dmemBytes(197) <= "00000000";
         dmemBytes(196) <= "00000000";
         dmemBytes(195) <= "00000000";
         dmemBytes(194) <= "00000000";
         dmemBytes(193) <= "00000000";
         dmemBytes(192) <= "00000000";
         
         dmemBytes(207) <= "00000000";
         dmemBytes(206) <= "00000000";
         dmemBytes(205) <= "00000000";
         dmemBytes(204) <= "00000000";
         dmemBytes(203) <= "00000000";
         dmemBytes(202) <= "00000000";
         dmemBytes(201) <= "00000000";
         dmemBytes(200) <= "00000000";
         
         dmemBytes(215) <= "00000000";
         dmemBytes(214) <= "00000000";
         dmemBytes(213) <= "00000000";
         dmemBytes(212) <= "00000000";
         dmemBytes(211) <= "00000000";
         dmemBytes(210) <= "00000000";
         dmemBytes(209) <= "00000000";
         dmemBytes(208) <= "00000000";
         
         dmemBytes(223) <= "00000000";
         dmemBytes(222) <= "00000000";
         dmemBytes(221) <= "00000000";
         dmemBytes(220) <= "00000000";
         dmemBytes(219) <= "00000000";
         dmemBytes(218) <= "00000000";
         dmemBytes(217) <= "00000000";
         dmemBytes(216) <= "00000000";
         
         dmemBytes(231) <= "00000000";
         dmemBytes(230) <= "00000000";
         dmemBytes(229) <= "00000000";
         dmemBytes(228) <= "00000000";
         dmemBytes(227) <= "00000000";
         dmemBytes(226) <= "00000000";
         dmemBytes(225) <= "00000000";
         dmemBytes(224) <= "00000000";
         
         dmemBytes(239) <= "00000000";
         dmemBytes(238) <= "00000000";
         dmemBytes(237) <= "00000000";
         dmemBytes(236) <= "00000000";
         dmemBytes(235) <= "00000000";
         dmemBytes(234) <= "00000000";
         dmemBytes(233) <= "00000000";
         dmemBytes(232) <= "00000000";
         
         dmemBytes(247) <= "00000000";
         dmemBytes(246) <= "00000000";
         dmemBytes(245) <= "00000000";
         dmemBytes(244) <= "00000000";
         dmemBytes(243) <= "00000000";
         dmemBytes(242) <= "00000000";
         dmemBytes(241) <= "00000000";
         dmemBytes(240) <= "00000000";
         
         dmemBytes(255) <= "00000000";
         dmemBytes(254) <= "00000000";
         dmemBytes(253) <= "00000000";
         dmemBytes(252) <= "00000000";
         dmemBytes(251) <= "00000000";
         dmemBytes(250) <= "00000000";
         dmemBytes(249) <= "00000000";
         dmemBytes(248) <= "00000000";
         
         dmemBytes(263) <= "00000000";
         dmemBytes(262) <= "00000000";
         dmemBytes(261) <= "00000000";
         dmemBytes(260) <= "00000000";
         dmemBytes(259) <= "00000000";
         dmemBytes(258) <= "00000000";
         dmemBytes(257) <= "00000000";
         dmemBytes(256) <= "00000000";
         
         dmemBytes(271) <= "00000000";
         dmemBytes(270) <= "00000000";
         dmemBytes(269) <= "00000000";
         dmemBytes(268) <= "00000000";
         dmemBytes(267) <= "00000000";
         dmemBytes(266) <= "00000000";
         dmemBytes(265) <= "00000000";
         dmemBytes(264) <= "00000000";
         
         dmemBytes(279) <= "00000000";
         dmemBytes(278) <= "00000000";
         dmemBytes(277) <= "00000000";
         dmemBytes(276) <= "00000000";
         dmemBytes(275) <= "00000000";
         dmemBytes(274) <= "00000000";
         dmemBytes(273) <= "00000000";
         dmemBytes(272) <= "00000000";
         
         dmemBytes(287) <= "00000000";
         dmemBytes(286) <= "00000000";
         dmemBytes(285) <= "00000000";
         dmemBytes(284) <= "00000000";
         dmemBytes(283) <= "00000000";
         dmemBytes(282) <= "00000000";
         dmemBytes(281) <= "00000000";
         dmemBytes(280) <= "00000000";
         
         dmemBytes(295) <= "00000000";
         dmemBytes(294) <= "00000000";
         dmemBytes(293) <= "00000000";
         dmemBytes(292) <= "00000000";
         dmemBytes(291) <= "00000000";
         dmemBytes(290) <= "00000000";
         dmemBytes(289) <= "00000000";
         dmemBytes(288) <= "00000000";
         
         dmemBytes(303) <= "00000000";
         dmemBytes(302) <= "00000000";
         dmemBytes(301) <= "00000000";
         dmemBytes(300) <= "00000000";
         dmemBytes(299) <= "00000000";
         dmemBytes(298) <= "00000000";
         dmemBytes(297) <= "00000000";
         dmemBytes(296) <= "00000000";
         
         dmemBytes(311) <= "00000000";
         dmemBytes(310) <= "00000000";
         dmemBytes(309) <= "00000000";
         dmemBytes(308) <= "00000000";
         dmemBytes(307) <= "00000000";
         dmemBytes(306) <= "00000000";
         dmemBytes(305) <= "00000000";
         dmemBytes(304) <= "00000000";
         
         dmemBytes(319) <= "00000000";
         dmemBytes(318) <= "00000000";
         dmemBytes(317) <= "00000000";
         dmemBytes(316) <= "00000000";
         dmemBytes(315) <= "00000000";
         dmemBytes(314) <= "00000000";
         dmemBytes(313) <= "00000000";
         dmemBytes(312) <= "00000000";
         
         dmemBytes(327) <= "00000000";
         dmemBytes(326) <= "00000000";
         dmemBytes(325) <= "00000000";
         dmemBytes(324) <= "00000000";
         dmemBytes(323) <= "00000000";
         dmemBytes(322) <= "00000000";
         dmemBytes(321) <= "00000000";
         dmemBytes(320) <= "00000000";
         
         dmemBytes(335) <= "00000000";
         dmemBytes(334) <= "00000000";
         dmemBytes(333) <= "00000000";
         dmemBytes(332) <= "00000000";
         dmemBytes(331) <= "00000000";
         dmemBytes(330) <= "00000000";
         dmemBytes(329) <= "00000000";
         dmemBytes(328) <= "00000000";
         
         dmemBytes(343) <= "00000000";
         dmemBytes(342) <= "00000000";
         dmemBytes(341) <= "00000000";
         dmemBytes(340) <= "00000000";
         dmemBytes(339) <= "00000000";
         dmemBytes(338) <= "00000000";
         dmemBytes(337) <= "00000000";
         dmemBytes(336) <= "00000000";
         
         dmemBytes(351) <= "00000000";
         dmemBytes(350) <= "00000000";
         dmemBytes(349) <= "00000000";
         dmemBytes(348) <= "00000000";
         dmemBytes(347) <= "00000000";
         dmemBytes(346) <= "00000000";
         dmemBytes(345) <= "00000000";
         dmemBytes(344) <= "00000000";
         
         dmemBytes(359) <= "00000000";
         dmemBytes(358) <= "00000000";
         dmemBytes(357) <= "00000000";
         dmemBytes(356) <= "00000000";
         dmemBytes(355) <= "00000000";
         dmemBytes(354) <= "00000000";
         dmemBytes(353) <= "00000000";
         dmemBytes(352) <= "00000000";
         
         dmemBytes(367) <= "00000000";
         dmemBytes(366) <= "00000000";
         dmemBytes(365) <= "00000000";
         dmemBytes(364) <= "00000000";
         dmemBytes(363) <= "00000000";
         dmemBytes(362) <= "00000000";
         dmemBytes(361) <= "00000000";
         dmemBytes(360) <= "00000000";
         
         dmemBytes(375) <= "00000000";
         dmemBytes(374) <= "00000000";
         dmemBytes(373) <= "00000000";
         dmemBytes(372) <= "00000000";
         dmemBytes(371) <= "00000000";
         dmemBytes(370) <= "00000000";
         dmemBytes(369) <= "00000000";
         dmemBytes(368) <= "00000000";
         
         dmemBytes(383) <= "00000000";
         dmemBytes(382) <= "00000000";
         dmemBytes(381) <= "00000000";
         dmemBytes(380) <= "00000000";
         dmemBytes(379) <= "00000000";
         dmemBytes(378) <= "00000000";
         dmemBytes(377) <= "00000000";
         dmemBytes(376) <= "00000000";
         
         dmemBytes(391) <= "00000000";
         dmemBytes(390) <= "00000000";
         dmemBytes(389) <= "00000000";
         dmemBytes(388) <= "00000000";
         dmemBytes(387) <= "00000000";
         dmemBytes(386) <= "00000000";
         dmemBytes(385) <= "00000000";
         dmemBytes(384) <= "00000000";
         
         dmemBytes(399) <= "00000000";
         dmemBytes(398) <= "00000000";
         dmemBytes(397) <= "00000000";
         dmemBytes(396) <= "00000000";
         dmemBytes(395) <= "00000000";
         dmemBytes(394) <= "00000000";
         dmemBytes(393) <= "00000000";
         dmemBytes(392) <= "00000000";
         
         dmemBytes(407) <= "00000000";
         dmemBytes(406) <= "00000000";
         dmemBytes(405) <= "00000000";
         dmemBytes(404) <= "00000000";
         dmemBytes(403) <= "00000000";
         dmemBytes(402) <= "00000000";
         dmemBytes(401) <= "00000000";
         dmemBytes(400) <= "00000000";
         
         dmemBytes(415) <= "00000000";
         dmemBytes(414) <= "00000000";
         dmemBytes(413) <= "00000000";
         dmemBytes(412) <= "00000000";
         dmemBytes(411) <= "00000000";
         dmemBytes(410) <= "00000000";
         dmemBytes(409) <= "00000000";
         dmemBytes(408) <= "00000000";
         
         dmemBytes(423) <= "00000000";
         dmemBytes(422) <= "00000000";
         dmemBytes(421) <= "00000000";
         dmemBytes(420) <= "00000000";
         dmemBytes(419) <= "00000000";
         dmemBytes(418) <= "00000000";
         dmemBytes(417) <= "00000000";
         dmemBytes(416) <= "00000000";
         
         dmemBytes(431) <= "00000000";
         dmemBytes(430) <= "00000000";
         dmemBytes(429) <= "00000000";
         dmemBytes(428) <= "00000000";
         dmemBytes(427) <= "00000000";
         dmemBytes(426) <= "00000000";
         dmemBytes(425) <= "00000000";
         dmemBytes(424) <= "00000000";
         
         dmemBytes(439) <= "00000000";
         dmemBytes(438) <= "00000000";
         dmemBytes(437) <= "00000000";
         dmemBytes(436) <= "00000000";
         dmemBytes(435) <= "00000000";
         dmemBytes(434) <= "00000000";
         dmemBytes(433) <= "00000000";
         dmemBytes(432) <= "00000000";
         
         dmemBytes(447) <= "00000000";
         dmemBytes(446) <= "00000000";
         dmemBytes(445) <= "00000000";
         dmemBytes(444) <= "00000000";
         dmemBytes(443) <= "00000000";
         dmemBytes(442) <= "00000000";
         dmemBytes(441) <= "00000000";
         dmemBytes(440) <= "00000000";
         
         dmemBytes(455) <= "00000000";
         dmemBytes(454) <= "00000000";
         dmemBytes(453) <= "00000000";
         dmemBytes(452) <= "00000000";
         dmemBytes(451) <= "00000000";
         dmemBytes(450) <= "00000000";
         dmemBytes(449) <= "00000000";
         dmemBytes(448) <= "00000000";
         
         dmemBytes(463) <= "00000000";
         dmemBytes(462) <= "00000000";
         dmemBytes(461) <= "00000000";
         dmemBytes(460) <= "00000000";
         dmemBytes(459) <= "00000000";
         dmemBytes(458) <= "00000000";
         dmemBytes(457) <= "00000000";
         dmemBytes(456) <= "00000000";
         
         dmemBytes(471) <= "00000000";
         dmemBytes(470) <= "00000000";
         dmemBytes(469) <= "00000000";
         dmemBytes(468) <= "00000000";
         dmemBytes(467) <= "00000000";
         dmemBytes(466) <= "00000000";
         dmemBytes(465) <= "00000000";
         dmemBytes(464) <= "00000000";
         
         dmemBytes(479) <= "00000000";
         dmemBytes(478) <= "00000000";
         dmemBytes(477) <= "00000000";
         dmemBytes(476) <= "00000000";
         dmemBytes(475) <= "00000000";
         dmemBytes(474) <= "00000000";
         dmemBytes(473) <= "00000000";
         dmemBytes(472) <= "00000000";
         
         dmemBytes(487) <= "00000000";
         dmemBytes(486) <= "00000000";
         dmemBytes(485) <= "00000000";
         dmemBytes(484) <= "00000000";
         dmemBytes(483) <= "00000000";
         dmemBytes(482) <= "00000000";
         dmemBytes(481) <= "00000000";
         dmemBytes(480) <= "00000000";
         
         dmemBytes(495) <= "00000000";
         dmemBytes(494) <= "00000000";
         dmemBytes(493) <= "00000000";
         dmemBytes(492) <= "00000000";
         dmemBytes(491) <= "00000000";
         dmemBytes(490) <= "00000000";
         dmemBytes(489) <= "00000000";
         dmemBytes(488) <= "00000000";
         
         dmemBytes(503) <= "00000000";
         dmemBytes(502) <= "00000000";
         dmemBytes(501) <= "00000000";
         dmemBytes(500) <= "00000000";
         dmemBytes(499) <= "00000000";
         dmemBytes(498) <= "00000000";
         dmemBytes(497) <= "00000000";
         dmemBytes(496) <= "00000000";
         
         dmemBytes(511) <= "00000000";
         dmemBytes(510) <= "00000000";
         dmemBytes(509) <= "00000000";
         dmemBytes(508) <= "00000000";
         dmemBytes(507) <= "00000000";
         dmemBytes(506) <= "00000000";
         dmemBytes(505) <= "00000000";
         dmemBytes(504) <= "00000000";
         
         dmemBytes(519) <= "00000000";
         dmemBytes(518) <= "00000000";
         dmemBytes(517) <= "00000000";
         dmemBytes(516) <= "00000000";
         dmemBytes(515) <= "00000000";
         dmemBytes(514) <= "00000000";
         dmemBytes(513) <= "00000000";
         dmemBytes(512) <= "00000000";
         
         dmemBytes(527) <= "00000000";
         dmemBytes(526) <= "00000000";
         dmemBytes(525) <= "00000000";
         dmemBytes(524) <= "00000000";
         dmemBytes(523) <= "00000000";
         dmemBytes(522) <= "00000000";
         dmemBytes(521) <= "00000000";
         dmemBytes(520) <= "00000000";
         
         dmemBytes(535) <= "00000000";
         dmemBytes(534) <= "00000000";
         dmemBytes(533) <= "00000000";
         dmemBytes(532) <= "00000000";
         dmemBytes(531) <= "00000000";
         dmemBytes(530) <= "00000000";
         dmemBytes(529) <= "00000000";
         dmemBytes(528) <= "00000000";
         
         dmemBytes(543) <= "00000000";
         dmemBytes(542) <= "00000000";
         dmemBytes(541) <= "00000000";
         dmemBytes(540) <= "00000000";
         dmemBytes(539) <= "00000000";
         dmemBytes(538) <= "00000000";
         dmemBytes(537) <= "00000000";
         dmemBytes(536) <= "00000000";
         
         dmemBytes(551) <= "00000000";
         dmemBytes(550) <= "00000000";
         dmemBytes(549) <= "00000000";
         dmemBytes(548) <= "00000000";
         dmemBytes(547) <= "00000000";
         dmemBytes(546) <= "00000000";
         dmemBytes(545) <= "00000000";
         dmemBytes(544) <= "00000000";
         
         dmemBytes(559) <= "00000000";
         dmemBytes(558) <= "00000000";
         dmemBytes(557) <= "00000000";
         dmemBytes(556) <= "00000000";
         dmemBytes(555) <= "00000000";
         dmemBytes(554) <= "00000000";
         dmemBytes(553) <= "00000000";
         dmemBytes(552) <= "00000000";
         
         dmemBytes(567) <= "00000000";
         dmemBytes(566) <= "00000000";
         dmemBytes(565) <= "00000000";
         dmemBytes(564) <= "00000000";
         dmemBytes(563) <= "00000000";
         dmemBytes(562) <= "00000000";
         dmemBytes(561) <= "00000000";
         dmemBytes(560) <= "00000000";
         
         dmemBytes(575) <= "00000000";
         dmemBytes(574) <= "00000000";
         dmemBytes(573) <= "00000000";
         dmemBytes(572) <= "00000000";
         dmemBytes(571) <= "00000000";
         dmemBytes(570) <= "00000000";
         dmemBytes(569) <= "00000000";
         dmemBytes(568) <= "00000000";
         
         dmemBytes(583) <= "00000000";
         dmemBytes(582) <= "00000000";
         dmemBytes(581) <= "00000000";
         dmemBytes(580) <= "00000000";
         dmemBytes(579) <= "00000000";
         dmemBytes(578) <= "00000000";
         dmemBytes(577) <= "00000000";
         dmemBytes(576) <= "00000000";
         
         dmemBytes(591) <= "00000000";
         dmemBytes(590) <= "00000000";
         dmemBytes(589) <= "00000000";
         dmemBytes(588) <= "00000000";
         dmemBytes(587) <= "00000000";
         dmemBytes(586) <= "00000000";
         dmemBytes(585) <= "00000000";
         dmemBytes(584) <= "00000000";
         
         dmemBytes(599) <= "00000000";
         dmemBytes(598) <= "00000000";
         dmemBytes(597) <= "00000000";
         dmemBytes(596) <= "00000000";
         dmemBytes(595) <= "00000000";
         dmemBytes(594) <= "00000000";
         dmemBytes(593) <= "00000000";
         dmemBytes(592) <= "00000000";
         
         dmemBytes(607) <= "00000000";
         dmemBytes(606) <= "00000000";
         dmemBytes(605) <= "00000000";
         dmemBytes(604) <= "00000000";
         dmemBytes(603) <= "00000000";
         dmemBytes(602) <= "00000000";
         dmemBytes(601) <= "00000000";
         dmemBytes(600) <= "00000000";
         
         dmemBytes(615) <= "00000000";
         dmemBytes(614) <= "00000000";
         dmemBytes(613) <= "00000000";
         dmemBytes(612) <= "00000000";
         dmemBytes(611) <= "00000000";
         dmemBytes(610) <= "00000000";
         dmemBytes(609) <= "00000000";
         dmemBytes(608) <= "00000000";
         
         dmemBytes(623) <= "00000000";
         dmemBytes(622) <= "00000000";
         dmemBytes(621) <= "00000000";
         dmemBytes(620) <= "00000000";
         dmemBytes(619) <= "00000000";
         dmemBytes(618) <= "00000000";
         dmemBytes(617) <= "00000000";
         dmemBytes(616) <= "00000000";
         
         dmemBytes(631) <= "00000000";
         dmemBytes(630) <= "00000000";
         dmemBytes(629) <= "00000000";
         dmemBytes(628) <= "00000000";
         dmemBytes(627) <= "00000000";
         dmemBytes(626) <= "00000000";
         dmemBytes(625) <= "00000000";
         dmemBytes(624) <= "00000000";
         
         dmemBytes(639) <= "00000000";
         dmemBytes(638) <= "00000000";
         dmemBytes(637) <= "00000000";
         dmemBytes(636) <= "00000000";
         dmemBytes(635) <= "00000000";
         dmemBytes(634) <= "00000000";
         dmemBytes(633) <= "00000000";
         dmemBytes(632) <= "00000000";
         
         dmemBytes(647) <= "00000000";
         dmemBytes(646) <= "00000000";
         dmemBytes(645) <= "00000000";
         dmemBytes(644) <= "00000000";
         dmemBytes(643) <= "00000000";
         dmemBytes(642) <= "00000000";
         dmemBytes(641) <= "00000000";
         dmemBytes(640) <= "00000000";
         
         dmemBytes(655) <= "00000000";
         dmemBytes(654) <= "00000000";
         dmemBytes(653) <= "00000000";
         dmemBytes(652) <= "00000000";
         dmemBytes(651) <= "00000000";
         dmemBytes(650) <= "00000000";
         dmemBytes(649) <= "00000000";
         dmemBytes(648) <= "00000000";
         
         dmemBytes(663) <= "00000000";
         dmemBytes(662) <= "00000000";
         dmemBytes(661) <= "00000000";
         dmemBytes(660) <= "00000000";
         dmemBytes(659) <= "00000000";
         dmemBytes(658) <= "00000000";
         dmemBytes(657) <= "00000000";
         dmemBytes(656) <= "00000000";
         
         dmemBytes(671) <= "00000000";
         dmemBytes(670) <= "00000000";
         dmemBytes(669) <= "00000000";
         dmemBytes(668) <= "00000000";
         dmemBytes(667) <= "00000000";
         dmemBytes(666) <= "00000000";
         dmemBytes(665) <= "00000000";
         dmemBytes(664) <= "00000000";
         
         dmemBytes(679) <= "00000000";
         dmemBytes(678) <= "00000000";
         dmemBytes(677) <= "00000000";
         dmemBytes(676) <= "00000000";
         dmemBytes(675) <= "00000000";
         dmemBytes(674) <= "00000000";
         dmemBytes(673) <= "00000000";
         dmemBytes(672) <= "00000000";
         
         dmemBytes(687) <= "00000000";
         dmemBytes(686) <= "00000000";
         dmemBytes(685) <= "00000000";
         dmemBytes(684) <= "00000000";
         dmemBytes(683) <= "00000000";
         dmemBytes(682) <= "00000000";
         dmemBytes(681) <= "00000000";
         dmemBytes(680) <= "00000000";
         
         dmemBytes(695) <= "00000000";
         dmemBytes(694) <= "00000000";
         dmemBytes(693) <= "00000000";
         dmemBytes(692) <= "00000000";
         dmemBytes(691) <= "00000000";
         dmemBytes(690) <= "00000000";
         dmemBytes(689) <= "00000000";
         dmemBytes(688) <= "00000000";
         
         dmemBytes(703) <= "00000000";
         dmemBytes(702) <= "00000000";
         dmemBytes(701) <= "00000000";
         dmemBytes(700) <= "00000000";
         dmemBytes(699) <= "00000000";
         dmemBytes(698) <= "00000000";
         dmemBytes(697) <= "00000000";
         dmemBytes(696) <= "00000000";
         
         dmemBytes(711) <= "00000000";
         dmemBytes(710) <= "00000000";
         dmemBytes(709) <= "00000000";
         dmemBytes(708) <= "00000000";
         dmemBytes(707) <= "00000000";
         dmemBytes(706) <= "00000000";
         dmemBytes(705) <= "00000000";
         dmemBytes(704) <= "00000000";
         
         dmemBytes(719) <= "00000000";
         dmemBytes(718) <= "00000000";
         dmemBytes(717) <= "00000000";
         dmemBytes(716) <= "00000000";
         dmemBytes(715) <= "00000000";
         dmemBytes(714) <= "00000000";
         dmemBytes(713) <= "00000000";
         dmemBytes(712) <= "00000000";
         
         dmemBytes(727) <= "00000000";
         dmemBytes(726) <= "00000000";
         dmemBytes(725) <= "00000000";
         dmemBytes(724) <= "00000000";
         dmemBytes(723) <= "00000000";
         dmemBytes(722) <= "00000000";
         dmemBytes(721) <= "00000000";
         dmemBytes(720) <= "00000000";
         
         dmemBytes(735) <= "00000000";
         dmemBytes(734) <= "00000000";
         dmemBytes(733) <= "00000000";
         dmemBytes(732) <= "00000000";
         dmemBytes(731) <= "00000000";
         dmemBytes(730) <= "00000000";
         dmemBytes(729) <= "00000000";
         dmemBytes(728) <= "00000000";
         
         dmemBytes(743) <= "00000000";
         dmemBytes(742) <= "00000000";
         dmemBytes(741) <= "00000000";
         dmemBytes(740) <= "00000000";
         dmemBytes(739) <= "00000000";
         dmemBytes(738) <= "00000000";
         dmemBytes(737) <= "00000000";
         dmemBytes(736) <= "00000000";
         
         dmemBytes(751) <= "00000000";
         dmemBytes(750) <= "00000000";
         dmemBytes(749) <= "00000000";
         dmemBytes(748) <= "00000000";
         dmemBytes(747) <= "00000000";
         dmemBytes(746) <= "00000000";
         dmemBytes(745) <= "00000000";
         dmemBytes(744) <= "00000000";
         
         dmemBytes(759) <= "00000000";
         dmemBytes(758) <= "00000000";
         dmemBytes(757) <= "00000000";
         dmemBytes(756) <= "00000000";
         dmemBytes(755) <= "00000000";
         dmemBytes(754) <= "00000000";
         dmemBytes(753) <= "00000000";
         dmemBytes(752) <= "00000000";
         
         dmemBytes(767) <= "00000000";
         dmemBytes(766) <= "00000000";
         dmemBytes(765) <= "00000000";
         dmemBytes(764) <= "00000000";
         dmemBytes(763) <= "00000000";
         dmemBytes(762) <= "00000000";
         dmemBytes(761) <= "00000000";
         dmemBytes(760) <= "00000000";
         
         dmemBytes(775) <= "00000000";
         dmemBytes(774) <= "00000000";
         dmemBytes(773) <= "00000000";
         dmemBytes(772) <= "00000000";
         dmemBytes(771) <= "00000000";
         dmemBytes(770) <= "00000000";
         dmemBytes(769) <= "00000000";
         dmemBytes(768) <= "00000000";
         
         dmemBytes(783) <= "00000000";
         dmemBytes(782) <= "00000000";
         dmemBytes(781) <= "00000000";
         dmemBytes(780) <= "00000000";
         dmemBytes(779) <= "00000000";
         dmemBytes(778) <= "00000000";
         dmemBytes(777) <= "00000000";
         dmemBytes(776) <= "00000000";
         
         dmemBytes(791) <= "00000000";
         dmemBytes(790) <= "00000000";
         dmemBytes(789) <= "00000000";
         dmemBytes(788) <= "00000000";
         dmemBytes(787) <= "00000000";
         dmemBytes(786) <= "00000000";
         dmemBytes(785) <= "00000000";
         dmemBytes(784) <= "00000000";
         
         dmemBytes(799) <= "00000000";
         dmemBytes(798) <= "00000000";
         dmemBytes(797) <= "00000000";
         dmemBytes(796) <= "00000000";
         dmemBytes(795) <= "00000000";
         dmemBytes(794) <= "00000000";
         dmemBytes(793) <= "00000000";
         dmemBytes(792) <= "00000000";
         
         dmemBytes(807) <= "00000000";
         dmemBytes(806) <= "00000000";
         dmemBytes(805) <= "00000000";
         dmemBytes(804) <= "00000000";
         dmemBytes(803) <= "00000000";
         dmemBytes(802) <= "00000000";
         dmemBytes(801) <= "00000000";
         dmemBytes(800) <= "00000000";
         
         dmemBytes(815) <= "00000000";
         dmemBytes(814) <= "00000000";
         dmemBytes(813) <= "00000000";
         dmemBytes(812) <= "00000000";
         dmemBytes(811) <= "00000000";
         dmemBytes(810) <= "00000000";
         dmemBytes(809) <= "00000000";
         dmemBytes(808) <= "00000000";
         
         dmemBytes(823) <= "00000000";
         dmemBytes(822) <= "00000000";
         dmemBytes(821) <= "00000000";
         dmemBytes(820) <= "00000000";
         dmemBytes(819) <= "00000000";
         dmemBytes(818) <= "00000000";
         dmemBytes(817) <= "00000000";
         dmemBytes(816) <= "00000000";
         
         dmemBytes(831) <= "00000000";
         dmemBytes(830) <= "00000000";
         dmemBytes(829) <= "00000000";
         dmemBytes(828) <= "00000000";
         dmemBytes(827) <= "00000000";
         dmemBytes(826) <= "00000000";
         dmemBytes(825) <= "00000000";
         dmemBytes(824) <= "00000000";
         
         dmemBytes(839) <= "00000000";
         dmemBytes(838) <= "00000000";
         dmemBytes(837) <= "00000000";
         dmemBytes(836) <= "00000000";
         dmemBytes(835) <= "00000000";
         dmemBytes(834) <= "00000000";
         dmemBytes(833) <= "00000000";
         dmemBytes(832) <= "00000000";
         
         dmemBytes(847) <= "00000000";
         dmemBytes(846) <= "00000000";
         dmemBytes(845) <= "00000000";
         dmemBytes(844) <= "00000000";
         dmemBytes(843) <= "00000000";
         dmemBytes(842) <= "00000000";
         dmemBytes(841) <= "00000000";
         dmemBytes(840) <= "00000000";
         
         dmemBytes(855) <= "00000000";
         dmemBytes(854) <= "00000000";
         dmemBytes(853) <= "00000000";
         dmemBytes(852) <= "00000000";
         dmemBytes(851) <= "00000000";
         dmemBytes(850) <= "00000000";
         dmemBytes(849) <= "00000000";
         dmemBytes(848) <= "00000000";
         
         dmemBytes(863) <= "00000000";
         dmemBytes(862) <= "00000000";
         dmemBytes(861) <= "00000000";
         dmemBytes(860) <= "00000000";
         dmemBytes(859) <= "00000000";
         dmemBytes(858) <= "00000000";
         dmemBytes(857) <= "00000000";
         dmemBytes(856) <= "00000000";
         
         dmemBytes(871) <= "00000000";
         dmemBytes(870) <= "00000000";
         dmemBytes(869) <= "00000000";
         dmemBytes(868) <= "00000000";
         dmemBytes(867) <= "00000000";
         dmemBytes(866) <= "00000000";
         dmemBytes(865) <= "00000000";
         dmemBytes(864) <= "00000000";
         
         dmemBytes(879) <= "00000000";
         dmemBytes(878) <= "00000000";
         dmemBytes(877) <= "00000000";
         dmemBytes(876) <= "00000000";
         dmemBytes(875) <= "00000000";
         dmemBytes(874) <= "00000000";
         dmemBytes(873) <= "00000000";
         dmemBytes(872) <= "00000000";
         
         dmemBytes(887) <= "00000000";
         dmemBytes(886) <= "00000000";
         dmemBytes(885) <= "00000000";
         dmemBytes(884) <= "00000000";
         dmemBytes(883) <= "00000000";
         dmemBytes(882) <= "00000000";
         dmemBytes(881) <= "00000000";
         dmemBytes(880) <= "00000000";
         
         dmemBytes(895) <= "00000000";
         dmemBytes(894) <= "00000000";
         dmemBytes(893) <= "00000000";
         dmemBytes(892) <= "00000000";
         dmemBytes(891) <= "00000000";
         dmemBytes(890) <= "00000000";
         dmemBytes(889) <= "00000000";
         dmemBytes(888) <= "00000000";
         
         dmemBytes(903) <= "00000000";
         dmemBytes(902) <= "00000000";
         dmemBytes(901) <= "00000000";
         dmemBytes(900) <= "00000000";
         dmemBytes(899) <= "00000000";
         dmemBytes(898) <= "00000000";
         dmemBytes(897) <= "00000000";
         dmemBytes(896) <= "00000000";
         
         dmemBytes(911) <= "00000000";
         dmemBytes(910) <= "00000000";
         dmemBytes(909) <= "00000000";
         dmemBytes(908) <= "00000000";
         dmemBytes(907) <= "00000000";
         dmemBytes(906) <= "00000000";
         dmemBytes(905) <= "00000000";
         dmemBytes(904) <= "00000000";
         
         dmemBytes(919) <= "00000000";
         dmemBytes(918) <= "00000000";
         dmemBytes(917) <= "00000000";
         dmemBytes(916) <= "00000000";
         dmemBytes(915) <= "00000000";
         dmemBytes(914) <= "00000000";
         dmemBytes(913) <= "00000000";
         dmemBytes(912) <= "00000000";
         
         dmemBytes(927) <= "00000000";
         dmemBytes(926) <= "00000000";
         dmemBytes(925) <= "00000000";
         dmemBytes(924) <= "00000000";
         dmemBytes(923) <= "00000000";
         dmemBytes(922) <= "00000000";
         dmemBytes(921) <= "00000000";
         dmemBytes(920) <= "00000000";
         
         dmemBytes(935) <= "00000000";
         dmemBytes(934) <= "00000000";
         dmemBytes(933) <= "00000000";
         dmemBytes(932) <= "00000000";
         dmemBytes(931) <= "00000000";
         dmemBytes(930) <= "00000000";
         dmemBytes(929) <= "00000000";
         dmemBytes(928) <= "00000000";
         
         dmemBytes(943) <= "00000000";
         dmemBytes(942) <= "00000000";
         dmemBytes(941) <= "00000000";
         dmemBytes(940) <= "00000000";
         dmemBytes(939) <= "00000000";
         dmemBytes(938) <= "00000000";
         dmemBytes(937) <= "00000000";
         dmemBytes(936) <= "00000000";
         
         dmemBytes(951) <= "00000000";
         dmemBytes(950) <= "00000000";
         dmemBytes(949) <= "00000000";
         dmemBytes(948) <= "00000000";
         dmemBytes(947) <= "00000000";
         dmemBytes(946) <= "00000000";
         dmemBytes(945) <= "00000000";
         dmemBytes(944) <= "00000000";
         
         dmemBytes(959) <= "00000000";
         dmemBytes(958) <= "00000000";
         dmemBytes(957) <= "00000000";
         dmemBytes(956) <= "00000000";
         dmemBytes(955) <= "00000000";
         dmemBytes(954) <= "00000000";
         dmemBytes(953) <= "00000000";
         dmemBytes(952) <= "00000000";
         
         dmemBytes(967) <= "00000000";
         dmemBytes(966) <= "00000000";
         dmemBytes(965) <= "00000000";
         dmemBytes(964) <= "00000000";
         dmemBytes(963) <= "00000000";
         dmemBytes(962) <= "00000000";
         dmemBytes(961) <= "00000000";
         dmemBytes(960) <= "00000000";
         
         dmemBytes(975) <= "00000000";
         dmemBytes(974) <= "00000000";
         dmemBytes(973) <= "00000000";
         dmemBytes(972) <= "00000000";
         dmemBytes(971) <= "00000000";
         dmemBytes(970) <= "00000000";
         dmemBytes(969) <= "00000000";
         dmemBytes(968) <= "00000000";
         
         dmemBytes(983) <= "00000000";
         dmemBytes(982) <= "00000000";
         dmemBytes(981) <= "00000000";
         dmemBytes(980) <= "00000000";
         dmemBytes(979) <= "00000000";
         dmemBytes(978) <= "00000000";
         dmemBytes(977) <= "00000000";
         dmemBytes(976) <= "00000000";
         
         dmemBytes(991) <= "00000000";
         dmemBytes(990) <= "00000000";
         dmemBytes(989) <= "00000000";
         dmemBytes(988) <= "00000000";
         dmemBytes(987) <= "00000000";
         dmemBytes(986) <= "00000000";
         dmemBytes(985) <= "00000000";
         dmemBytes(984) <= "00000000";
         
         dmemBytes(999) <= "00000000";
         dmemBytes(998) <= "00000000";
         dmemBytes(997) <= "00000000";
         dmemBytes(996) <= "00000000";
         dmemBytes(995) <= "00000000";
         dmemBytes(994) <= "00000000";
         dmemBytes(993) <= "00000000";
         dmemBytes(992) <= "00000000";
         
         dmemBytes(1007) <= "00000000";
         dmemBytes(1006) <= "00000000";
         dmemBytes(1005) <= "00000000";
         dmemBytes(1004) <= "00000000";
         dmemBytes(1003) <= "00000000";
         dmemBytes(1002) <= "00000000";
         dmemBytes(1001) <= "00000000";
         dmemBytes(1000) <= "00000000";
         
         dmemBytes(1015) <= "00000000";
         dmemBytes(1014) <= "00000000";
         dmemBytes(1013) <= "00000000";
         dmemBytes(1012) <= "00000000";
         dmemBytes(1011) <= "00000000";
         dmemBytes(1010) <= "00000000";
         dmemBytes(1009) <= "00000000";
         dmemBytes(1008) <= "00000000";
         
         dmemBytes(1023) <= "00000000";
         dmemBytes(1022) <= "00000000";
         dmemBytes(1021) <= "00000000";
         dmemBytes(1020) <= "00000000";
         dmemBytes(1019) <= "00000000";
         dmemBytes(1018) <= "00000000";
         dmemBytes(1017) <= "00000000";
         dmemBytes(1016) <= "00000000";
         
	 -- Follow the pattern and write the rest of the code; initialize memory cells with 0
         first := false; -- Don't initialize the next time this process runs
      end if;

      -- The 'proper' HDL starts here!
      if Clock = '1' and Clock'event and MemWrite='1' and MemRead='0' then 
         -- Write on the rising edge of the clock
         addr:=to_integer(unsigned(Address)); -- Convert the address to an integer
         -- Slice the input data into bytes and assign to the byte array
         dmemBytes(addr+7) <= WriteData(63 downto 56);
         dmemBytes(addr+6) <= WriteData(55 downto 48);
         dmemBytes(addr+5) <= WriteData(47 downto 40);
         dmemBytes(addr+4) <= WriteData(39 downto 32);
         dmemBytes(addr+3) <= WriteData(31 downto 24);
         dmemBytes(addr+2) <= WriteData(23 downto 16);
         dmemBytes(addr+1) <= WriteData(15 downto 8);
         dmemBytes(addr)   <= WriteData(7 downto 0);
      elsif MemRead='1' and MemWrite='0' then -- Reads don't need to be edge triggered
         addr:=to_integer(unsigned(Address)); -- Convert the address
         if (addr+7 < NUM_BYTES) then -- Check that the address is within the bounds of the memory
           ReadData <= dmemBytes(addr+7) & dmemBytes(addr+6) &
                       dmemBytes(addr+5) & dmemBytes(addr+4) &
	               dmemBytes(addr+3) & dmemBytes(addr+2) &
                       dmemBytes(addr+1) & dmemBytes(addr+0);
         else report "Invalid DMEM addr. Attempted to read 4-bytes starting at address"
            severity error;
         end if;
      end if;
   end process;
   
   -- Conntect the signals that will be used for testing
   -- you can add debugging signals here
   DEBUG_MEM_CONTENTS <=
      dmemBytes( 0) & dmemBytes( 1) & dmemBytes( 2) & dmemBytes( 3) & --DMEM(0)
      dmemBytes( 4) & dmemBytes( 5) & dmemBytes( 6) & dmemBytes( 7) & --DMEM(4)
      dmemBytes( 8) & dmemBytes( 9) & dmemBytes(10) & dmemBytes(11) & --DMEM(8)
      dmemBytes(12) & dmemBytes(13) & dmemBytes(14) & dmemBytes(15)&  --DMEM(12)
      dmemBytes( 16) & dmemBytes( 17) & dmemBytes( 18) & dmemBytes( 19) & --DMEM(11)
      dmemBytes( 20) & dmemBytes( 21) & dmemBytes( 22) & dmemBytes( 23) & --DMEMM(20)
      dmemBytes( 24) & dmemBytes( 25) & dmemBytes(26) & dmemBytes(27) & --DMEM(22)
      dmemBytes(28) & dmemBytes(29) & dmemBytes(30) & dmemBytes(31);  --DMEM(28) 
end behavioral;

	 

