#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir(A_ScriptDir)
#MaxThreadsPerHotkey 1

; ================================
; ======== LOOT SECTION ==========
; ================================
; === PUBG Quick Loot Macro (4 slots, smooth & reliable) ===
; ปุ่ม: Mouse Button 5 (กดครั้งเดียว = เก็บหลายช่อง)

; ---- ตำแหน่งปรับได้ตามจอคุณ ----
X1 :=         ; จุดของชิ้นแรกในกล่อง (ฝั่งซ้าย)
Y1 := 
X2 :=        ; จุดช่องกระเป๋าที่จะวาง (ฝั่งขวา)
Y2 := 
Step := 40       ; ระยะห่างแนวตั้งระหว่างไอเทมแต่ละชิ้น (35–45px ส่วนใหญ่)
Total := 10       ; จำนวนช่องที่จะเก็บ

; ---- จูนความสมูท/ความชัวร์ ----
MoveSpeed := 5   ; ความเร็ว MouseMove (0 = เร็วสุด, 5 = ลื่น/รับอินพุตดีขึ้น)
PreDelay  := 25  ; หน่วงก่อนเริ่มแต่ละชิ้น
HoldDown  := 25  ; เวลากดค้างเมาส์ก่อนลาก (กันลากหลุด)
Between   := 35  ; หน่วงหลังปล่อย ก่อนขึ้นชิ้นถัดไป
Jitter    := 2   ; ขยับพิกัดสุ่ม ±พิกเซล (0–3 พอ)

; ---- ฟังก์ชันช่วยจูน ----
randSleep(base, spread := 8) {
    local v := Round(base + Random(-spread, spread))
    if (v < 0) v := 0
    Sleep v
}
j(px) {
    return Round(Random(-px, px))
}

dragOnce(y) {
    global X1, X2, Y2, MoveSpeed, PreDelay, HoldDown, Between, Jitter
    randSleep(PreDelay)

    ; ไปหาไอเทม (มีจิเตอร์เล็กน้อย)
    MouseMove X1 + j(Jitter), y + j(Jitter), MoveSpeed
    randSleep(8)

    Click "Down"
    randSleep(HoldDown)                  ; ให้เกมจับคลิกค้างได้ชัวร์

    ; ลากไปช่องกระเป๋า (ไม่ต้องเร็วสุดเพื่อให้รับอินพุตเสถียร)
    MouseMove X2 + j(Jitter), Y2 + j(Jitter), MoveSpeed
    randSleep(12)

    Click "Up"
    randSleep(Between)
}

XButton2::{
    global Y1, Step, Total, isLooting
    isLooting := true          ; บอก aim ว่ากำลัง loot อยู่ หยุดกันดีดก่อน

    local currentY := Y1
    Loop Total
    {
        dragOnce(currentY)
        currentY += Step
    }

    isLooting := false         ; loot เสร็จแล้ว เปิดกันดีดได้ตามปกติ
}

; ปิดโปรแกรมด้วย Ctrl+Esc
^Esc::ExitApp()