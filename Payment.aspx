<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Payment.aspx.cs" Inherits="EventGlint.Payment" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>EventGlint | Payment</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800;900&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        :root {
            --violet:      #7C3AED;
            --violet-mid:  #9D5CF8;
            --violet-soft: #EDE9FE;
            --violet-glow: rgba(124,58,237,.14);
            --bg:          #F7F5FF;
            --surface:     #FFFFFF;
            --surface2:    #F1EEF9;
            --border-soft: rgba(0,0,0,.06);
            --text:        #1A1033;
            --muted:       #8B7BB0;
            --gold:        #E88C1A;
            --green:       #16A34A;
            --green-soft:  #DCFCE7;
            --red:         #DC2626;
            --shadow-sm:   0 1px 4px rgba(124,58,237,.07);
            --shadow-md:   0 4px 20px rgba(124,58,237,.10);
            --radius:      18px;
            --sidebar:     264px;
        }
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Plus Jakarta Sans', sans-serif; background: var(--bg); color: var(--text); }
        a { text-decoration: none; }
        #form1 { display: contents; }
        .layout { display: flex; min-height: 100vh; }

        /* SIDEBAR */
        .sidebar { width: var(--sidebar); min-height: 100vh; background: var(--surface); border-right: 1px solid var(--border-soft); display: flex; flex-direction: column; position: fixed; top: 0; left: 0; z-index: 100; padding: 30px 0; box-shadow: 2px 0 20px rgba(124,58,237,.06); }
        .sidebar::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 4px; background: linear-gradient(90deg, var(--violet), var(--violet-mid), #C084FC); }
        .sidebar-logo { display: flex; align-items: center; gap: 13px; padding: 0 24px 30px; border-bottom: 1px solid var(--border-soft); }
        .logo-icon { width: 44px; height: 44px; background: linear-gradient(135deg, var(--violet), var(--violet-mid)); border-radius: 14px; display: grid; place-items: center; font-size: 20px; flex-shrink: 0; }
        .logo-text { font-family: 'Playfair Display', serif; font-weight: 800; font-size: 17px; line-height: 1.2; color: var(--text); }
        .logo-text span { font-family: 'Plus Jakarta Sans', sans-serif; color: var(--muted); font-size: 11px; font-weight: 400; display: block; margin-top: 2px; }
        .nav { padding: 26px 14px; flex: 1; display: flex; flex-direction: column; gap: 3px; }
        .nav-label { font-size: 10px; text-transform: uppercase; letter-spacing: .14em; color: var(--muted); padding: 0 10px; margin: 14px 0 6px; font-weight: 600; }
        .nav-item { display: flex; align-items: center; gap: 12px; padding: 11px 14px; border-radius: 12px; font-size: 14px; font-weight: 500; color: var(--muted); text-decoration: none; transition: all .2s; }
        .nav-item:hover { background: var(--violet-soft); color: var(--violet); }
        .nav-item.active { background: linear-gradient(135deg, var(--violet-soft), #DDD6FE); color: var(--violet); font-weight: 600; }
        .nav-item .icon { font-size: 17px; width: 22px; text-align: center; }
        .sidebar-bottom { padding: 20px; border-top: 1px solid var(--border-soft); }
        .user-card { display: flex; align-items: center; gap: 12px; padding: 12px 14px; border-radius: 14px; background: var(--surface2); border: 1px solid var(--border-soft); }
        .avatar { width: 38px; height: 38px; background: linear-gradient(135deg, var(--violet), #C084FC); border-radius: 50%; display: grid; place-items: center; font-weight: 700; font-size: 15px; color: #fff; flex-shrink: 0; }
        .user-info .user-name { font-size: 13px; font-weight: 600; color: var(--text); }
        .user-info .user-role { font-size: 11px; color: var(--muted); margin-top: 1px; }

        /* MAIN */
        .main { margin-left: var(--sidebar); flex: 1; display: flex; flex-direction: column; }
        .topbar { height: 70px; background: rgba(247,245,255,.95); backdrop-filter: blur(24px); border-bottom: 1px solid var(--border-soft); display: flex; align-items: center; padding: 0 32px; gap: 16px; position: sticky; top: 0; z-index: 90; }
        .topbar-back { display: flex; align-items: center; gap: 8px; font-size: 14px; font-weight: 600; color: var(--muted); padding: 8px 14px; border-radius: 20px; background: var(--surface); border: 1px solid var(--border-soft); transition: all .2s; text-decoration: none; }
        .topbar-back:hover { color: var(--violet); border-color: var(--violet); background: var(--violet-soft); }
        .topbar-title { font-family: 'Playfair Display', serif; font-size: 18px; font-weight: 800; color: var(--text); }
        .topbar-right { margin-left: auto; display: flex; align-items: center; gap: 10px; }

        .content { padding: 28px 32px 50px; flex: 1; max-width: 860px; }

        /* SUCCESS BANNER */
        .success-banner {
            background: linear-gradient(135deg, #DCFCE7, #BBF7D0);
            border: 1.5px solid #86EFAC;
            border-radius: var(--radius);
            padding: 20px 24px;
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 24px;
            animation: fadeUp .4s ease both;
        }
        .success-icon { font-size: 36px; flex-shrink: 0; }
        .success-title { font-family: 'Playfair Display', serif; font-size: 18px; font-weight: 800; color: #15803D; }
        .success-sub { font-size: 13px; color: #166534; margin-top: 3px; }
        .ref-badge { display: inline-block; background: #15803D; color: #fff; font-size: 12px; font-weight: 700; padding: 3px 10px; border-radius: 20px; margin-top: 6px; letter-spacing: .04em; }

        /* TIMER */
        .timer-bar { background: var(--surface); border: 1px solid var(--border-soft); border-radius: var(--radius); padding: 14px 20px; display: flex; align-items: center; gap: 14px; margin-bottom: 24px; box-shadow: var(--shadow-sm); animation: fadeUp .4s .05s ease both; }
        .timer-icon { font-size: 22px; }
        .timer-text { font-size: 13px; color: var(--muted); flex: 1; }
        .timer-text strong { color: var(--text); }
        .timer-count { font-family: 'Playfair Display', serif; font-size: 22px; font-weight: 900; color: var(--violet); min-width: 56px; text-align: right; }
        .timer-count.urgent { color: var(--red); }

        /* GRID */
        .pay-grid { display: grid; grid-template-columns: 1fr 300px; gap: 22px; align-items: start; }

        /* PANEL */
        .panel { background: var(--surface); border: 1px solid var(--border-soft); border-radius: var(--radius); box-shadow: var(--shadow-sm); overflow: hidden; margin-bottom: 18px; animation: fadeUp .4s .1s ease both; }
        .panel-head { padding: 16px 20px; border-bottom: 1px solid var(--border-soft); display: flex; align-items: center; gap: 12px; }
        .panel-icon { width: 36px; height: 36px; border-radius: 10px; background: var(--violet-soft); display: grid; place-items: center; font-size: 17px; flex-shrink: 0; }
        .panel-title { font-family: 'Playfair Display', serif; font-size: 15px; font-weight: 800; color: var(--text); }
        .panel-body { padding: 20px; }

        /* BOOKING SUMMARY ROWS */
        .info-row { display: flex; justify-content: space-between; padding: 9px 0; border-bottom: 1px solid var(--border-soft); font-size: 13px; }
        .info-row:last-child { border-bottom: none; }
        .info-row .lbl { color: var(--muted); font-weight: 500; }
        .info-row .val { color: var(--text); font-weight: 600; text-align: right; }
        .info-row .val.green { color: var(--green); }
        .info-row .val.gold  { color: var(--gold); font-family: 'Playfair Display', serif; font-size: 16px; }

        /* PAYMENT METHODS */
        .pay-methods { display: flex; flex-direction: column; gap: 10px; }
        .pay-method { border: 2px solid var(--border-soft); border-radius: 14px; padding: 14px 16px; display: flex; align-items: center; gap: 14px; cursor: pointer; transition: all .2s; }
        .pay-method:hover { border-color: rgba(124,58,237,.3); background: var(--violet-soft); }
        .pay-method.selected { border-color: var(--violet); background: var(--violet-soft); box-shadow: 0 0 0 3px var(--violet-glow); }
        .pay-method-icon { font-size: 24px; width: 36px; text-align: center; flex-shrink: 0; }
        .pay-method-label { font-size: 14px; font-weight: 600; color: var(--text); }
        .pay-method-sub { font-size: 11px; color: var(--muted); margin-top: 2px; }
        .pay-method-radio { margin-left: auto; width: 18px; height: 18px; border-radius: 50%; border: 2px solid var(--border-soft); display: grid; place-items: center; flex-shrink: 0; }
        .pay-method.selected .pay-method-radio { border-color: var(--violet); background: var(--violet); }
        .pay-method.selected .pay-method-radio::after { content: ''; width: 6px; height: 6px; background: #fff; border-radius: 50%; }

        /* UPI INPUT */
        .upi-input-wrap { margin-top: 14px; display: none; }
        .upi-input-wrap.show { display: block; }
        .upi-input { width: 100%; padding: 10px 14px; border: 1.5px solid var(--border-soft); border-radius: 12px; font-size: 14px; font-family: 'Plus Jakarta Sans', sans-serif; color: var(--text); background: var(--surface); outline: none; transition: border .2s; }
        .upi-input:focus { border-color: var(--violet); }

        /* CARD INPUTS */
        .card-inputs { margin-top: 14px; display: none; flex-direction: column; gap: 10px; }
        .card-inputs.show { display: flex; }
        .card-row { display: flex; gap: 10px; }
        .field-label { font-size: 11px; font-weight: 600; color: var(--muted); margin-bottom: 4px; }
        .field-input { width: 100%; padding: 10px 14px; border: 1.5px solid var(--border-soft); border-radius: 12px; font-size: 14px; font-family: 'Plus Jakarta Sans', sans-serif; color: var(--text); background: var(--surface); outline: none; transition: border .2s; }
        .field-input:focus { border-color: var(--violet); }

        /* ORDER SUMMARY (right) */
        .order-panel { background: var(--surface); border: 1px solid var(--border-soft); border-radius: var(--radius); box-shadow: var(--shadow-md); overflow: hidden; position: sticky; top: 88px; animation: fadeUp .4s .15s ease both; }
        .order-head { padding: 16px 18px; background: linear-gradient(135deg, #5B21B6, #7C3AED, #A855F7); }
        .order-head h3 { font-family: 'Playfair Display', serif; font-size: 16px; font-weight: 900; color: #fff; }
        .order-head p { font-size: 11px; color: rgba(255,255,255,.7); margin-top: 2px; }
        .order-body { padding: 16px 18px; }
        .order-total { display: flex; justify-content: space-between; align-items: center; padding: 14px 18px; background: var(--violet-soft); border-top: 2px solid rgba(124,58,237,.15); }
        .order-total .lbl { font-size: 14px; font-weight: 700; }
        .order-total .val { font-family: 'Playfair Display', serif; font-size: 22px; font-weight: 900; color: var(--violet); }

        /* PAY BUTTON */
        .pay-btn { width: 100%; padding: 15px; background: linear-gradient(135deg, var(--green), #15803D); color: #fff; border: none; border-radius: 14px; font-size: 15px; font-weight: 800; cursor: pointer; font-family: 'Plus Jakarta Sans', sans-serif; margin-top: 16px; transition: all .2s; box-shadow: 0 6px 20px rgba(22,163,74,.3); }
        .pay-btn:hover { transform: translateY(-2px); box-shadow: 0 10px 28px rgba(22,163,74,.4); }
        .pay-btn:disabled { opacity: .5; cursor: not-allowed; transform: none; }

        .msg-box { padding: 12px 16px; border-radius: 12px; font-size: 13px; font-weight: 600; margin-bottom: 16px; }
        .msg-success { background: #DCFCE7; color: #15803D; border: 1px solid #BBF7D0; }
        .msg-error   { background: #FEE2E2; color: #DC2626; border: 1px solid #FECACA; }

        @keyframes fadeUp { from { opacity:0; transform:translateY(12px); } to { opacity:1; transform:translateY(0); } }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <%-- Hidden field: JS writes selected payment method before postback --%>
    <input type="hidden" id="hdnPayMethod" name="hdnPayMethod" value="UPI" />
<div class="layout">

    <!-- SIDEBAR -->
    <aside class="sidebar">
        <div class="sidebar-logo">
            <div class="logo-icon">🎯</div>
            <div class="logo-text">EventNearMe<span>Discover Local Events</span></div>
        </div>
        <nav class="nav">
            <div class="nav-label">Menu</div>
            <a class="nav-item" href="Home.aspx"><span class="icon">🏠</span> Home</a>
            <a class="nav-item" href="Event.aspx"><span class="icon">🎪</span> Event</a>
            <a class="nav-item" href="Shows.aspx"><span class="icon">🎭</span> Shows</a>
            <a class="nav-item" href="Hall.aspx"><span class="icon">🏛️</span> Hall</a>
            <a class="nav-item active" href="Bookings.aspx"><span class="icon">🎟️</span> My Bookings</a>
            <a class="nav-item" href="ContactUs.aspx"><span class="icon">📞</span> Contact Us</a>
        </nav>
        <div class="sidebar-bottom">
            <div class="user-card">
                <div class="avatar"><asp:Label ID="lblAvatarInitial" runat="server" Text="U" /></div>
                <div class="user-info">
                    <div class="user-name"><asp:Label ID="lblUserName" runat="server" Text="User" /></div>
                    <div class="user-role"><asp:Label ID="lblUserRole" runat="server" Text="Member" /></div>
                </div>
            </div>
        </div>
    </aside>

    <!-- MAIN -->
    <main class="main">
        <header class="topbar">
            <a class="topbar-back" href="Bookings.aspx">← My Bookings</a>
            <div class="topbar-title">💳 Complete Payment</div>
            <div class="topbar-right">
                <div class="avatar" style="width:42px;height:42px;border:2.5px solid var(--violet)">
                    <asp:Label ID="lblTopAvatar" runat="server" Text="U" />
                </div>
            </div>
        </header>

        <div class="content">

            <asp:Label ID="lblMessage" runat="server" Visible="false" />

            <!-- ✅ SUCCESS BANNER -->
            <div class="success-banner">
                <div class="success-icon">🎉</div>
                <div>
                    <div class="success-title">Booking Created Successfully!</div>
                    <div class="success-sub">Your seats are held for 10 minutes. Complete payment to confirm.</div>
                    <div class="ref-badge">Ref: <asp:Label ID="lblBookingRef" runat="server" Text="—" /></div>
                </div>
            </div>

            <!-- SEAT HOLD TIMER -->
            <div class="timer-bar">
                <div class="timer-icon">⏳</div>
                <div class="timer-text">
                    <strong>Seats are reserved!</strong> Complete payment before the timer expires or your seats will be released.
                </div>
                <div class="timer-count" id="timerDisplay">10:00</div>
            </div>

            <div class="pay-grid">

                <!-- LEFT: PAYMENT METHODS -->
                <div>
                    <div class="panel">
                        <div class="panel-head">
                            <div class="panel-icon">💳</div>
                            <div class="panel-title">Choose Payment Method</div>
                        </div>
                        <div class="panel-body">
                            <div class="pay-methods">

                                <!-- UPI -->
                                <div class="pay-method selected" onclick="selectMethod(this,'upi')">
                                    <div class="pay-method-icon">📱</div>
                                    <div>
                                        <div class="pay-method-label">UPI</div>
                                        <div class="pay-method-sub">GPay, PhonePe, Paytm, BHIM</div>
                                    </div>
                                    <div class="pay-method-radio"></div>
                                </div>
                                <div class="upi-input-wrap show" id="upiWrap">
                                    <input type="text" class="upi-input" id="upiId" placeholder="Enter UPI ID e.g. name@upi" />
                                </div>

                                <!-- Credit / Debit Card -->
                                <div class="pay-method" onclick="selectMethod(this,'card')">
                                    <div class="pay-method-icon">💳</div>
                                    <div>
                                        <div class="pay-method-label">Credit / Debit Card</div>
                                        <div class="pay-method-sub">Visa, Mastercard, RuPay</div>
                                    </div>
                                    <div class="pay-method-radio"></div>
                                </div>
                                <div class="card-inputs" id="cardWrap">
                                    <div>
                                        <div class="field-label">Card Number</div>
                                        <input type="text" class="field-input" id="cardNum" maxlength="19" placeholder="1234 5678 9012 3456" oninput="fmtCard(this)" />
                                    </div>
                                    <div class="card-row">
                                        <div style="flex:1">
                                            <div class="field-label">Expiry</div>
                                            <input type="text" class="field-input" id="cardExp" maxlength="5" placeholder="MM/YY" oninput="fmtExp(this)" />
                                        </div>
                                        <div style="flex:1">
                                            <div class="field-label">CVV</div>
                                            <input type="text" class="field-input" id="cardCvv" maxlength="4" placeholder="•••" />
                                        </div>
                                    </div>
                                    <div>
                                        <div class="field-label">Name on Card</div>
                                        <input type="text" class="field-input" id="cardName" placeholder="As printed on card" />
                                    </div>
                                </div>

                                <!-- Net Banking -->
                                <div class="pay-method" onclick="selectMethod(this,'netbanking')">
                                    <div class="pay-method-icon">🏦</div>
                                    <div>
                                        <div class="pay-method-label">Net Banking</div>
                                        <div class="pay-method-sub">All major Indian banks</div>
                                    </div>
                                    <div class="pay-method-radio"></div>
                                </div>

                                <!-- Cash on Venue -->
                                <div class="pay-method" onclick="selectMethod(this,'cash')">
                                    <div class="pay-method-icon">💵</div>
                                    <div>
                                        <div class="pay-method-label">Pay at Venue</div>
                                        <div class="pay-method-sub">Cash counter at the venue</div>
                                    </div>
                                    <div class="pay-method-radio"></div>
                                </div>

                            </div>
                        </div>
                    </div>

                    <!-- BOOKING DETAILS PANEL -->
                    <div class="panel">
                        <div class="panel-head">
                            <div class="panel-icon">🎟️</div>
                            <div class="panel-title">Booking Details</div>
                        </div>
                        <div class="panel-body">
                            <div class="info-row">
                                <span class="lbl">Event</span>
                                <span class="val"><asp:Label ID="lblEvent" runat="server" Text="—" /></span>
                            </div>
                            <div class="info-row">
                                <span class="lbl">Show</span>
                                <span class="val"><asp:Label ID="lblShow" runat="server" Text="—" /></span>
                            </div>
                            <div class="info-row">
                                <span class="lbl">Venue</span>
                                <span class="val"><asp:Label ID="lblVenue" runat="server" Text="—" /></span>
                            </div>
                            <div class="info-row">
                                <span class="lbl">Seats</span>
                                <span class="val"><asp:Label ID="lblSeats" runat="server" Text="—" /></span>
                            </div>
                            <div class="info-row">
                                <span class="lbl">Booking Ref</span>
                                <span class="val"><asp:Label ID="lblRef" runat="server" Text="—" /></span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- RIGHT: ORDER SUMMARY -->
                <div>
                    <div class="order-panel">
                        <div class="order-head">
                            <h3>🧾 Amount Due</h3>
                            <p>Review before paying</p>
                        </div>
                        <div class="order-body">
                            <div class="info-row">
                                <span class="lbl">Subtotal</span>
                                <span class="val">₹<asp:Label ID="lblSubtotal" runat="server" Text="0" /></span>
                            </div>
                            <div class="info-row">
                                <span class="lbl">Convenience Fee (2%)</span>
                                <span class="val">₹<asp:Label ID="lblFee" runat="server" Text="0" /></span>
                            </div>
                            <div class="info-row">
                                <span class="lbl" style="color:var(--green)">Discount</span>
                                <span class="val green">− ₹<asp:Label ID="lblDiscount" runat="server" Text="0" /></span>
                            </div>
                        </div>
                        <div class="order-total">
                            <span class="lbl">Total</span>
                            <span class="val">₹<asp:Label ID="lblTotal" runat="server" Text="0" /></span>
                        </div>
                        <div style="padding:14px 18px;">
                            <asp:Button ID="btnPay" runat="server"
                                Text="✅ Pay Now"
                                CssClass="pay-btn"
                                OnClick="btnPay_Click"
                                OnClientClick="return validatePayment();" />
                            <div style="text-align:center;margin-top:10px;font-size:11px;color:var(--muted)">
                                🔒 256-bit SSL secured payment
                            </div>
                        </div>
                    </div>
                </div>

            </div><!-- /pay-grid -->
        </div><!-- /content -->
    </main>
</div>
</form>

<script>
// ── Map JS method → DB PaymentMethod column value ────────────────────────
function methodToDb(method) {
    var map = { upi: 'UPI', card: 'CreditCard', netbanking: 'NetBanking', cash: 'COD' };
    return map[method] || 'UPI';
}

// ── Payment method selection ──────────────────────────────────────────────
var currentMethod = 'upi';

function selectMethod(el, method) {
    document.querySelectorAll('.pay-method').forEach(function(m) {
        m.classList.remove('selected');
    });
    el.classList.add('selected');
    currentMethod = method;
    document.getElementById("hdnPayMethod").value = methodToDb(method);

    document.getElementById('upiWrap').classList.remove('show');
    document.getElementById('cardWrap').classList.remove('show');

    if (method === 'upi')  document.getElementById('upiWrap').classList.add('show');
    if (method === 'card') document.getElementById('cardWrap').classList.add('show');
}

// ── Card formatting ───────────────────────────────────────────────────────
function fmtCard(el) {
    var v = el.value.replace(/\D/g, '').substring(0, 16);
    el.value = v.match(/.{1,4}/g) ? v.match(/.{1,4}/g).join(' ') : v;
}
function fmtExp(el) {
    var v = el.value.replace(/\D/g, '').substring(0, 4);
    el.value = v.length > 2 ? v.substring(0,2) + '/' + v.substring(2) : v;
}

// ── Validate before Pay Now postback ────────────────────────────────────
function validatePayment() {
    if (currentMethod === 'upi') {
        var upi = document.getElementById('upiId').value.trim();
        if (!upi || !upi.includes('@')) {
            alert('Please enter a valid UPI ID (e.g. name@upi)');
            return false;
        }
    }
    if (currentMethod === 'card') {
        var num  = document.getElementById('cardNum').value.replace(/\s/g,'');
        var exp  = document.getElementById('cardExp').value.trim();
        var cvv  = document.getElementById('cardCvv').value.trim();
        var name = document.getElementById('cardName').value.trim();
        if (num.length < 16)  { alert('Enter a valid 16-digit card number.'); return false; }
        if (exp.length < 5)   { alert('Enter a valid expiry date.'); return false; }
        if (cvv.length < 3)   { alert('Enter a valid CVV.'); return false; }
        if (!name)            { alert('Enter the name on card.'); return false; }
    }
    return true;
}

// ── 10-minute seat hold countdown ────────────────────────────────────────
var holdSeconds = 600;
var timerEl = document.getElementById('timerDisplay');

var timerInterval = setInterval(function() {
    holdSeconds--;
    if (holdSeconds <= 0) {
        clearInterval(timerInterval);
        timerEl.innerText = '00:00';
        timerEl.classList.add('urgent');
        alert('⚠️ Your seat hold has expired. Please restart your booking.');
        window.location.href = 'Home.aspx';
        return;
    }
    var m = Math.floor(holdSeconds / 60);
    var s = holdSeconds % 60;
    timerEl.innerText = (m < 10 ? '0' : '') + m + ':' + (s < 10 ? '0' : '') + s;
    if (holdSeconds <= 60) timerEl.classList.add('urgent');
}, 1000);
</script>
</body>
</html>
