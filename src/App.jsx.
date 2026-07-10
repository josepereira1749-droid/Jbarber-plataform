import React, { useState, useEffect, useMemo, useCallback } from "react";
import {
  Lock, Calendar, DollarSign, Scissors, Check, X, LogOut,
  Clock, Phone, User, ChevronLeft, ChevronRight, MessageCircle,
  MapPin, Eye, EyeOff, Trash2, TrendingUp, ListChecks, KeyRound,
  Instagram, Share2, Copy, QrCode
} from "lucide-react";
import { supabase } from "./supabaseClient";

/* ---------------------------------------------------------
   J. BARBER — Plataforma de reservas + panel de administración
   Datos guardados en Supabase (tablas: bookings, admin_config)
   para que el cliente que reserva y el barbero vean la misma
   agenda desde cualquier dispositivo.
--------------------------------------------------------- */

const BARBER_WHATSAPP = "56935929811"; // número del barbero, sin + ni espacios
const DEFAULT_PLATFORM_URL =
  typeof window !== "undefined" ? window.location.origin + "/" : "";

const CREATOR = {
  name: "José Pereira",
  title: "Técnico nivel sup. en Procesos Mineros",
  instagram: "https://www.instagram.com/j.pereyra_c?igsh=ZHVmejdjNXg4cG5i",
  instagramHandle: "@j.pereyra_c",
};

const SERVICES = [
  { id: "degradado", emoji: "💈", name: "Corte degradado", price: 10000, duration: 45, desc: "Degradado profesional con máquina y perfilado exacto." },
  { id: "tradicional", emoji: "✂️", name: "Corte tradicional", price: 9000, duration: 45, desc: "Corte clásico con tijera y máquina, acabado prolijo." },
  { id: "facial", emoji: "🧖", name: "Limpieza facial", price: 10000, duration: 45, desc: "Ritual facial con toalla caliente y productos premium." },
  { id: "cejas", emoji: "👁️", name: "Cejas", price: 2000, duration: 45, desc: "Perfilado de cejas prolijo y definido." },
  { id: "lineas", emoji: "🎨", name: "Líneas", price: 1000, duration: 45, desc: "Diseños y líneas artísticas personalizadas." },
];

const TIME_SLOTS = [
  "09:00","09:30","10:00","10:30","11:00","11:30","12:00","12:30",
  "14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30",
  "18:00","18:30","19:00","19:30"
];

const CLP = (n) => "$" + n.toLocaleString("es-CL");

function todayISO() {
  const d = new Date();
  return d.toISOString().slice(0, 10);
}

function fmtDateLabel(iso) {
  const d = new Date(iso + "T00:00:00");
  return d.toLocaleDateString("es-CL", { weekday: "long", day: "numeric", month: "long" });
}

/* ------------------------- Supabase helpers ------------------------- */

function rowToBooking(row) {
  return {
    id: row.id,
    name: row.name,
    phone: row.phone,
    serviceId: row.service_id,
    serviceName: row.service_name,
    price: row.price,
    date: row.date,
    time: row.time,
    status: row.status,
    createdAt: row.created_at,
  };
}

async function loadBookings() {
  const { data, error } = await supabase
    .from("bookings")
    .select("*")
    .order("date", { ascending: true })
    .order("time", { ascending: true });
  if (error) {
    console.error("Error cargando reservas:", error.message);
    return [];
  }
  return (data || []).map(rowToBooking);
}

async function insertBooking(booking) {
  const { error } = await supabase.from("bookings").insert({
    name: booking.name,
    phone: booking.phone,
    service_id: booking.serviceId,
    service_name: booking.serviceName,
    price: booking.price,
    date: booking.date,
    time: booking.time,
    status: booking.status,
  });
  return { ok: !error, error };
}

async function updateBookingStatus(id, status) {
  const { error } = await supabase.from("bookings").update({ status }).eq("id", id);
  if (error) console.error("Error actualizando reserva:", error.message);
}

async function deleteBookingRow(id) {
  const { error } = await supabase.from("bookings").delete().eq("id", id);
  if (error) console.error("Error eliminando reserva:", error.message);
}

async function loadAdminConfig() {
  const { data, error } = await supabase.from("admin_config").select("*").eq("id", 1).single();
  if (error || !data) {
    return { password: "barber2026", platformUrl: DEFAULT_PLATFORM_URL };
  }
  return { password: data.password, platformUrl: data.platform_url || DEFAULT_PLATFORM_URL };
}

async function saveAdminConfig(cfg) {
  const { error } = await supabase
    .from("admin_config")
    .update({ password: cfg.password, platform_url: cfg.platformUrl })
    .eq("id", 1);
  if (error) console.error("Error guardando configuración:", error.message);
}

/* ------------------------- Shared bits ------------------------- */

function Logo() {
  return (
    <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
      <div style={{
        width: 36, height: 36, borderRadius: 6,
        background: "linear-gradient(135deg,#C9A227,#8a6e15)",
        display: "flex", alignItems: "center", justifyContent: "center",
        boxShadow: "0 0 0 1px rgba(201,162,39,0.4)"
      }}>
        <Scissors size={18} color="#131311" strokeWidth={2.5} />
      </div>
      <span style={{ fontFamily: "'Bebas Neue', sans-serif", fontSize: 26, letterSpacing: 1.5, color: "#F4F1EA" }}>
        J. BARBER
      </span>
    </div>
  );
}

function CreatorSeal() {
  return (
    <div style={{
      display: "flex", alignItems: "center", justifyContent: "center", gap: 8,
      flexWrap: "wrap", fontSize: 11, color: "#5c5a51", padding: "14px 20px",
    }}>
      <span>Creador de la plataforma:</span>
      <span style={{ color: "#8C8A7D", fontWeight: 600 }}>{CREATOR.name}</span>
      <span>· {CREATOR.title}</span>
      <a
        href={CREATOR.instagram}
        target="_blank"
        rel="noreferrer"
        style={{ color: "#C9A227", display: "inline-flex", alignItems: "center", gap: 4, textDecoration: "none" }}
      >
        <Instagram size={12} /> {CREATOR.instagramHandle}
      </a>
    </div>
  );
}

function FontStyles() {
  return (
    <style>{`
      @import url('https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@500;600&display=swap');
      * { box-sizing: border-box; }
      body { margin: 0; }
      .jb-root { font-family: 'Inter', sans-serif; }
      .jb-mono { font-family: 'JetBrains Mono', monospace; }
      .jb-display { font-family: 'Bebas Neue', sans-serif; }
      .jb-fade { animation: jbfade .5s ease both; }
      @keyframes jbfade { from { opacity:0; transform: translateY(6px);} to {opacity:1; transform:none;} }
      .jb-slot:focus-visible, .jb-btn:focus-visible, .jb-input:focus-visible, .jb-select:focus-visible {
        outline: 2px solid #C9A227; outline-offset: 2px;
      }
      @media (prefers-reduced-motion: reduce) {
        .jb-fade { animation: none; }
      }
      ::selection { background: #C9A227; color: #131311; }
    `}</style>
  );
}

/* ============================================================
   CLIENT VIEW
============================================================ */

function ClientView({ bookings, refreshBookings, goAdmin }) {
  const [name, setName] = useState("");
  const [phone, setPhone] = useState("");
  const [serviceId, setServiceId] = useState(SERVICES[0].id);
  const [date, setDate] = useState(todayISO());
  const [time, setTime] = useState(null);
  const [submitting, setSubmitting] = useState(false);
  const [confirmed, setConfirmed] = useState(null);
  const [error, setError] = useState("");

  const service = SERVICES.find((s) => s.id === serviceId);

  const takenSlots = useMemo(() => {
    return new Set(
      bookings.filter((b) => b.date === date && b.status !== "cancelado").map((b) => b.time)
    );
  }, [bookings, date]);

  const handleSubmit = async () => {
    setError("");
    if (!name.trim()) return setError("Ingresá tu nombre.");
    if (!phone.trim()) return setError("Ingresá tu teléfono.");
    if (!time) return setError("Elegí un horario disponible.");
    if (takenSlots.has(time)) return setError("Ese horario se acaba de ocupar, elegí otro.");

    setSubmitting(true);
    const newBooking = {
      name: name.trim(),
      phone: phone.trim(),
      serviceId,
      serviceName: service.name,
      price: service.price,
      date,
      time,
      status: "confirmado",
    };
    const { ok, error: insertError } = await insertBooking(newBooking);
    await refreshBookings();
    setSubmitting(false);

    if (!ok) {
      // El código 23505 es "unique_violation": alguien reservó ese horario justo antes.
      if (insertError && insertError.code === "23505") {
        setError("Ese horario se acaba de ocupar, elegí otro.");
      } else {
        setError("No se pudo guardar la reserva. Probá de nuevo en unos segundos.");
      }
      return;
    }

    setConfirmed(newBooking);
    setName(""); setPhone(""); setTime(null);
  };

  if (confirmed) {
    return (
      <div className="jb-root jb-fade" style={{ minHeight: "100vh", background: "#131311", color: "#F4F1EA", display: "flex", alignItems: "center", justifyContent: "center", padding: 24 }}>
        <FontStyles />
        <div style={{ maxWidth: 420, width: "100%" }}>
          <div style={{ background: "#1C1C18", border: "1px solid #2c2c26", borderRadius: 14, padding: 32, textAlign: "center" }}>
            <div style={{ width: 56, height: 56, borderRadius: "50%", background: "#C9A227", display: "flex", alignItems: "center", justifyContent: "center", margin: "0 auto 18px" }}>
              <Check size={28} color="#131311" strokeWidth={3} />
            </div>
            <h2 className="jb-display" style={{ fontSize: 30, margin: "0 0 6px", letterSpacing: 1 }}>Reserva confirmada</h2>
            <p style={{ color: "#a9a89d", margin: "0 0 20px", fontSize: 14 }}>Te esperamos, {confirmed.name.split(" ")[0]}.</p>
            <div style={{ background: "#131311", borderRadius: 10, padding: 16, textAlign: "left", fontSize: 14, lineHeight: 1.9 }}>
              <div><span style={{ color: "#8C8A7D" }}>Servicio</span> — {confirmed.serviceName}</div>
              <div><span style={{ color: "#8C8A7D" }}>Fecha</span> — {fmtDateLabel(confirmed.date)}</div>
              <div><span style={{ color: "#8C8A7D" }}>Hora</span> — {confirmed.time}</div>
              <div className="jb-mono"><span style={{ color: "#8C8A7D", fontFamily: "'Inter',sans-serif" }}>Total</span> — {CLP(confirmed.price)}</div>
            </div>

            <p style={{ fontSize: 12, color: "#8C8A7D", marginTop: 16, lineHeight: 1.5 }}>
              Tocá el botón de abajo para avisarle al barbero por WhatsApp (se abre con el mensaje ya escrito).
            </p>
            <a
              href={`https://wa.me/${BARBER_WHATSAPP}?text=${encodeURIComponent(
                `Hola! Reservé un turno en J. Barber ✂️\n\n` +
                `Nombre: ${confirmed.name}\n` +
                `Servicio: ${confirmed.serviceName}\n` +
                `Fecha: ${fmtDateLabel(confirmed.date)}\n` +
                `Hora: ${confirmed.time}\n` +
                `Total: ${CLP(confirmed.price)}`
              )}`}
              target="_blank"
              rel="noreferrer"
              className="jb-btn"
              style={{
                marginTop: 14, width: "100%", padding: "12px 0", borderRadius: 8, border: "none",
                background: "#25D366", color: "#0b1f13", fontWeight: 700, fontSize: 14, cursor: "pointer",
                display: "flex", alignItems: "center", justifyContent: "center", gap: 8, textDecoration: "none",
              }}
            >
              <MessageCircle size={16} /> Avisar al barbero por WhatsApp
            </a>
            <button
              className="jb-btn"
              onClick={() => setConfirmed(null)}
              style={{ marginTop: 10, width: "100%", padding: "12px 0", borderRadius: 8, border: "1px solid #2c2c26", background: "transparent", color: "#c9c7ba", fontWeight: 600, fontSize: 14, cursor: "pointer" }}
            >
              Hacer otra reserva
            </button>
          </div>
          <CreatorSeal />
        </div>
      </div>
    );
  }

  return (
    <div className="jb-root" style={{ minHeight: "100vh", background: "#131311", color: "#F4F1EA" }}>
      <FontStyles />

      <header style={{ maxWidth: 900, margin: "0 auto", padding: "22px 20px 0", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <Logo />
        <button onClick={goAdmin} className="jb-btn" style={{
          background: "transparent", border: "1px solid #3a3a32", color: "#c9c7ba",
          padding: "8px 14px", borderRadius: 8, fontSize: 13, cursor: "pointer", display: "flex", gap: 6, alignItems: "center"
        }}>
          <Lock size={14} /> Barbero
        </button>
      </header>

      <section style={{ maxWidth: 900, margin: "0 auto", padding: "36px 20px 24px" }}>
        <div style={{ fontSize: 12, letterSpacing: 2, color: "#C9A227", textTransform: "uppercase", marginBottom: 10 }}>Reservas online</div>
        <h1 className="jb-display" style={{ fontSize: "clamp(38px,7vw,64px)", lineHeight: 0.95, margin: "0 0 14px", letterSpacing: 1 }}>
          Estilo, precisión<br />y buena vibra.
        </h1>
        <p style={{ color: "#a9a89d", fontSize: 16, maxWidth: 480, margin: "0 0 20px" }}>
          Reservá tu turno en segundos. Sin llamadas, sin esperas.
        </p>
        <div style={{ display: "flex", flexWrap: "wrap", gap: 18, fontSize: 13, color: "#c9c7ba" }}>
          <span style={{ display: "flex", gap: 6, alignItems: "center" }}><MapPin size={14} color="#C9A227" /> Sola Sierra Enríquez</span>
          <a href={`https://wa.me/${BARBER_WHATSAPP}`} target="_blank" rel="noreferrer" style={{ display: "flex", gap: 6, alignItems: "center", color: "#c9c7ba", textDecoration: "none" }}>
            <MessageCircle size={14} color="#C9A227" /> +56 9 3592 9811
          </a>
          <span style={{ display: "flex", gap: 6, alignItems: "center" }}><Clock size={14} color="#C9A227" /> Lunes a domingo (45 min por cliente)</span>
        </div>
      </section>

      <section style={{ maxWidth: 900, margin: "0 auto", padding: "20px 20px 10px" }}>
        <h2 className="jb-display" style={{ fontSize: 22, letterSpacing: 1, color: "#e8e6da", marginBottom: 14 }}>CATÁLOGO DE SERVICIOS</h2>
        <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fill,minmax(220px,1fr))", gap: 12 }}>
          {SERVICES.map((s) => (
            <button
              key={s.id}
              onClick={() => setServiceId(s.id)}
              className="jb-btn"
              style={{
                textAlign: "left", cursor: "pointer",
                background: serviceId === s.id ? "#26241a" : "#1C1C18",
                border: serviceId === s.id ? "1px solid #C9A227" : "1px solid #2c2c26",
                borderRadius: 12, padding: 16,
              }}
            >
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "start" }}>
                <span style={{ fontSize: 22 }}>{s.emoji}</span>
                <span className="jb-mono" style={{ color: "#C9A227", fontSize: 14 }}>{CLP(s.price)}</span>
              </div>
              <div style={{ fontWeight: 600, fontSize: 15, margin: "10px 0 4px", color: "#F4F1EA" }}>{s.name}</div>
              <div style={{ fontSize: 12.5, color: "#8C8A7D", lineHeight: 1.4 }}>{s.desc}</div>
              <div style={{ fontSize: 11.5, color: "#6f6d62", marginTop: 8 }}>Duración ~ {s.duration} min</div>
            </button>
          ))}
        </div>
      </section>

      <section style={{ maxWidth: 900, margin: "0 auto", padding: "30px 20px 60px" }}>
        <h2 className="jb-display" style={{ fontSize: 22, letterSpacing: 1, color: "#e8e6da", marginBottom: 14 }}>RESERVÁ TU TURNO</h2>

        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12, marginBottom: 12 }}>
          <div>
            <label style={{ fontSize: 12, color: "#8C8A7D" }}>Tu nombre</label>
            <input className="jb-input" value={name} onChange={(e) => setName(e.target.value)} placeholder="Nombre y apellido" style={inputStyle} />
          </div>
          <div>
            <label style={{ fontSize: 12, color: "#8C8A7D" }}>Teléfono</label>
            <input className="jb-input" value={phone} onChange={(e) => setPhone(e.target.value)} placeholder="+56 9 ..." style={inputStyle} />
          </div>
        </div>

        <div style={{ marginBottom: 12 }}>
          <label style={{ fontSize: 12, color: "#8C8A7D" }}>Fecha</label>
          <input type="date" className="jb-input" value={date} min={todayISO()} onChange={(e) => { setDate(e.target.value); setTime(null); }} style={inputStyle} />
        </div>

        <div style={{ marginBottom: 16 }}>
          <label style={{ fontSize: 12, color: "#8C8A7D" }}>Horarios disponibles — {fmtDateLabel(date)}</label>
          <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fill,minmax(72px,1fr))", gap: 8, marginTop: 8 }}>
            {TIME_SLOTS.map((t) => {
              const taken = takenSlots.has(t);
              const selected = time === t;
              return (
                <button
                  key={t}
                  disabled={taken}
                  onClick={() => setTime(t)}
                  className="jb-slot jb-mono"
                  style={{
                    padding: "10px 0", borderRadius: 8, fontSize: 13,
                    cursor: taken ? "not-allowed" : "pointer",
                    border: selected ? "1px solid #C9A227" : "1px solid #2c2c26",
                    background: taken ? "#1a1a17" : selected ? "#C9A227" : "#1C1C18",
                    color: taken ? "#55534a" : selected ? "#131311" : "#e8e6da",
                    textDecoration: taken ? "line-through" : "none",
                    fontWeight: selected ? 700 : 500,
                  }}
                >
                  {t}
                </button>
              );
            })}
          </div>
          <p style={{ fontSize: 11.5, color: "#6f6d62", marginTop: 8 }}>Los horarios tachados ya están ocupados.</p>
        </div>

        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", padding: "14px 16px", background: "#1C1C18", border: "1px solid #2c2c26", borderRadius: 10, marginBottom: 14 }}>
          <span style={{ fontSize: 13, color: "#a9a89d" }}>Precio del servicio</span>
          <span className="jb-mono" style={{ fontSize: 18, color: "#C9A227", fontWeight: 700 }}>{CLP(service.price)}</span>
        </div>

        {error && (
          <div style={{ background: "#3a1a1a", border: "1px solid #6b2a2a", color: "#f4b8b8", fontSize: 13, padding: "10px 14px", borderRadius: 8, marginBottom: 14 }}>
            {error}
          </div>
        )}

        <button
          onClick={handleSubmit}
          disabled={submitting}
          className="jb-btn"
          style={{
            width: "100%", padding: "14px 0", borderRadius: 10, border: "none",
            background: submitting ? "#8a6e15" : "#C9A227", color: "#131311",
            fontWeight: 700, fontSize: 15, cursor: submitting ? "default" : "pointer",
          }}
        >
          {submitting ? "Confirmando..." : "Confirmar reserva"}
        </button>
      </section>

      <footer style={{ borderTop: "1px solid #24241f" }}>
        <p style={{ textAlign: "center", fontSize: 11.5, color: "#6f6d62", padding: "18px 20px 0" }}>
          J. Barber — Sola Sierra Enríquez
        </p>
        <CreatorSeal />
      </footer>
    </div>
  );
}

const inputStyle = {
  width: "100%", marginTop: 6, padding: "11px 12px", borderRadius: 8,
  border: "1px solid #2c2c26", background: "#1C1C18", color: "#F4F1EA", fontSize: 14,
};

/* ============================================================
   ADMIN VIEW
============================================================ */

function AdminLogin({ onSuccess, goClient }) {
  const [pwd, setPwd] = useState("");
  const [show, setShow] = useState(false);
  const [error, setError] = useState("");
  const [checking, setChecking] = useState(false);

  const submit = async () => {
    setChecking(true);
    setError("");
    const cfg = await loadAdminConfig();
    if (pwd === cfg.password) {
      onSuccess();
    } else {
      setError("Clave incorrecta.");
    }
    setChecking(false);
  };

  return (
    <div className="jb-root jb-fade" style={{ minHeight: "100vh", background: "#131311", color: "#F4F1EA", display: "flex", alignItems: "center", justifyContent: "center", padding: 24 }}>
      <FontStyles />
      <div style={{ maxWidth: 380, width: "100%" }}>
        <div style={{ textAlign: "center", marginBottom: 26 }}>
          <Logo />
        </div>
        <div style={{ background: "#1C1C18", border: "1px solid #2c2c26", borderRadius: 14, padding: 28 }}>
          <div style={{ width: 46, height: 46, borderRadius: "50%", background: "#26241a", border: "1px solid #C9A227", display: "flex", alignItems: "center", justifyContent: "center", margin: "0 auto 16px" }}>
            <Lock size={20} color="#C9A227" />
          </div>
          <h2 className="jb-display" style={{ textAlign: "center", fontSize: 26, letterSpacing: 1, margin: "0 0 4px" }}>PANEL DEL BARBERO</h2>
          <p style={{ textAlign: "center", fontSize: 13, color: "#8C8A7D", margin: "0 0 20px" }}>Ingresá la contraseña para acceder.</p>

          <div style={{ position: "relative" }}>
            <input
              type={show ? "text" : "password"}
              value={pwd}
              onChange={(e) => setPwd(e.target.value)}
              onKeyDown={(e) => e.key === "Enter" && submit()}
              placeholder="Contraseña"
              className="jb-input"
              style={{ ...inputStyle, marginTop: 0, paddingRight: 40 }}
            />
            <button onClick={() => setShow((s) => !s)} className="jb-btn" style={{ position: "absolute", right: 8, top: 9, background: "none", border: "none", cursor: "pointer", color: "#8C8A7D" }}>
              {show ? <EyeOff size={16} /> : <Eye size={16} />}
            </button>
          </div>

          {error && <p style={{ color: "#f4b8b8", fontSize: 12.5, marginTop: 8 }}>{error}</p>}

          <button
            onClick={submit}
            disabled={checking}
            className="jb-btn"
            style={{ width: "100%", marginTop: 16, padding: "12px 0", borderRadius: 8, border: "none", background: "#C9A227", color: "#131311", fontWeight: 700, fontSize: 14, cursor: "pointer" }}
          >
            {checking ? "Verificando..." : "Entrar"}
          </button>

          <p style={{ fontSize: 11, color: "#5c5a51", marginTop: 14, textAlign: "center" }}>
            Clave por defecto: <span className="jb-mono">barber2026</span> (cambiala luego de entrar)
          </p>
        </div>
        <button onClick={goClient} className="jb-btn" style={{ display: "block", margin: "18px auto 0", background: "none", border: "none", color: "#8C8A7D", fontSize: 13, cursor: "pointer" }}>
          ← Volver al inicio
        </button>
      </div>
      <CreatorSeal />
    </div>
  );
}

function AdminDashboard({ bookings, refreshBookings, onLogout }) {
  const [tab, setTab] = useState("agenda");
  const [agendaDate, setAgendaDate] = useState(todayISO());
  const [reportRange, setReportRange] = useState("today");

  const dayBookings = useMemo(() => {
    return bookings.filter((b) => b.date === agendaDate).sort((a, b) => a.time.localeCompare(b.time));
  }, [bookings, agendaDate]);

  const shiftDay = (delta) => {
    const d = new Date(agendaDate + "T00:00:00");
    d.setDate(d.getDate() + delta);
    setAgendaDate(d.toISOString().slice(0, 10));
  };

  const updateStatus = async (id, status) => {
    await updateBookingStatus(id, status);
    await refreshBookings();
  };

  const deleteBooking = async (id) => {
    await deleteBookingRow(id);
    await refreshBookings();
  };

  const reportBookings = useMemo(() => {
    const now = new Date();
    const startOfWeek = new Date(now);
    startOfWeek.setDate(now.getDate() - now.getDay());
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);

    return bookings.filter((b) => {
      if (b.status === "cancelado") return false;
      const d = new Date(b.date + "T00:00:00");
      if (reportRange === "today") return b.date === todayISO();
      if (reportRange === "week") return d >= startOfWeek;
      if (reportRange === "month") return d >= startOfMonth;
      return true;
    });
  }, [bookings, reportRange]);

  const totalRevenue = reportBookings.reduce((sum, b) => sum + b.price, 0);
  const completedCount = reportBookings.filter((b) => b.status === "completado").length;

  const byService = useMemo(() => {
    const map = {};
    reportBookings.forEach((b) => { map[b.serviceName] = (map[b.serviceName] || 0) + b.price; });
    return Object.entries(map).sort((a, b) => b[1] - a[1]);
  }, [reportBookings]);

  return (
    <div className="jb-root" style={{ minHeight: "100vh", background: "#131311", color: "#F4F1EA" }}>
      <FontStyles />
      <header style={{ maxWidth: 1000, margin: "0 auto", padding: "20px 20px 0", display: "flex", justifyContent: "space-between", alignItems: "center", flexWrap: "wrap", gap: 12 }}>
        <Logo />
        <button onClick={onLogout} className="jb-btn" style={{ background: "transparent", border: "1px solid #3a3a32", color: "#c9c7ba", padding: "8px 14px", borderRadius: 8, fontSize: 13, cursor: "pointer", display: "flex", gap: 6, alignItems: "center" }}>
          <LogOut size={14} /> Salir
        </button>
      </header>

      <div style={{ maxWidth: 1000, margin: "0 auto", padding: "18px 20px 0" }}>
        <div style={{ display: "flex", gap: 8, borderBottom: "1px solid #24241f", flexWrap: "wrap" }}>
          {[
            { id: "agenda", label: "Agenda diaria", icon: Calendar },
            { id: "report", label: "Reporte financiero", icon: TrendingUp },
            { id: "share", label: "Compartir", icon: QrCode },
            { id: "settings", label: "Ajustes", icon: KeyRound },
          ].map(({ id, label, icon: Icon }) => (
            <button
              key={id}
              onClick={() => setTab(id)}
              className="jb-btn"
              style={{
                background: "none", border: "none", cursor: "pointer",
                padding: "10px 14px", fontSize: 13.5, display: "flex", gap: 6, alignItems: "center",
                color: tab === id ? "#C9A227" : "#8C8A7D",
                borderBottom: tab === id ? "2px solid #C9A227" : "2px solid transparent",
                fontWeight: tab === id ? 600 : 500,
              }}
            >
              <Icon size={15} /> {label}
            </button>
          ))}
        </div>
      </div>

      <main style={{ maxWidth: 1000, margin: "0 auto", padding: "24px 20px 60px" }}>
        {tab === "agenda" && (
          <div className="jb-fade">
            <div style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 18 }}>
              <button onClick={() => shiftDay(-1)} className="jb-btn" style={navBtnStyle}><ChevronLeft size={16} /></button>
              <div style={{ flex: 1, textAlign: "center" }}>
                <div className="jb-display" style={{ fontSize: 20, letterSpacing: 1, textTransform: "capitalize" }}>{fmtDateLabel(agendaDate)}</div>
                <input type="date" value={agendaDate} onChange={(e) => setAgendaDate(e.target.value)} style={{ marginTop: 4, background: "none", border: "none", color: "#8C8A7D", fontSize: 12 }} />
              </div>
              <button onClick={() => shiftDay(1)} className="jb-btn" style={navBtnStyle}><ChevronRight size={16} /></button>
            </div>

            {dayBookings.length === 0 ? (
              <div style={{ textAlign: "center", padding: "50px 20px", color: "#6f6d62" }}>
                <ListChecks size={30} style={{ marginBottom: 10, opacity: 0.5 }} />
                <p style={{ fontSize: 14 }}>No hay reservas para este día.</p>
              </div>
            ) : (
              <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
                {dayBookings.map((b) => (
                  <div key={b.id} style={{
                    display: "flex", alignItems: "center", gap: 14, background: "#1C1C18",
                    border: "1px solid #2c2c26", borderRadius: 10, padding: "14px 16px",
                    opacity: b.status === "cancelado" ? 0.5 : 1, flexWrap: "wrap",
                  }}>
                    <div className="jb-mono" style={{ fontSize: 15, color: "#C9A227", width: 56 }}>{b.time}</div>
                    <div style={{ flex: 1, minWidth: 160 }}>
                      <div style={{ fontWeight: 600, fontSize: 14, display: "flex", gap: 6, alignItems: "center" }}>
                        <User size={13} color="#8C8A7D" /> {b.name}
                      </div>
                      <div style={{ fontSize: 12.5, color: "#8C8A7D", display: "flex", gap: 12, marginTop: 3, flexWrap: "wrap" }}>
                        <span>{b.serviceName}</span>
                        <a href={`https://wa.me/${b.phone.replace(/\D/g, "")}`} target="_blank" rel="noreferrer" style={{ color: "#8C8A7D", display: "flex", gap: 4, alignItems: "center", textDecoration: "none" }}>
                          <Phone size={11} /> {b.phone}
                        </a>
                      </div>
                    </div>
                    <div className="jb-mono" style={{ fontSize: 14, color: "#e8e6da" }}>{CLP(b.price)}</div>
                    <span style={{
                      fontSize: 11, padding: "4px 9px", borderRadius: 20,
                      background: b.status === "completado" ? "#1f3a24" : b.status === "cancelado" ? "#3a1a1a" : "#26241a",
                      color: b.status === "completado" ? "#8fd39a" : b.status === "cancelado" ? "#f4b8b8" : "#C9A227",
                    }}>
                      {b.status}
                    </span>
                    <div style={{ display: "flex", gap: 6 }}>
                      {b.status !== "completado" && (
                        <button title="Marcar completado" onClick={() => updateStatus(b.id, "completado")} className="jb-btn" style={iconBtnStyle}><Check size={14} /></button>
                      )}
                      {b.status !== "cancelado" && (
                        <button title="Cancelar" onClick={() => updateStatus(b.id, "cancelado")} className="jb-btn" style={iconBtnStyle}><X size={14} /></button>
                      )}
                      <button title="Eliminar" onClick={() => deleteBooking(b.id)} className="jb-btn" style={iconBtnStyle}><Trash2 size={14} /></button>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        )}

        {tab === "report" && (
          <div className="jb-fade">
            <div style={{ display: "flex", gap: 8, marginBottom: 20, flexWrap: "wrap" }}>
              {[
                { id: "today", label: "Hoy" },
                { id: "week", label: "Esta semana" },
                { id: "month", label: "Este mes" },
                { id: "all", label: "Todo" },
              ].map((r) => (
                <button
                  key={r.id}
                  onClick={() => setReportRange(r.id)}
                  className="jb-btn"
                  style={{
                    padding: "8px 14px", borderRadius: 20, fontSize: 12.5, cursor: "pointer",
                    border: reportRange === r.id ? "1px solid #C9A227" : "1px solid #2c2c26",
                    background: reportRange === r.id ? "#26241a" : "transparent",
                    color: reportRange === r.id ? "#C9A227" : "#8C8A7D",
                  }}
                >
                  {r.label}
                </button>
              ))}
            </div>

            <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit,minmax(180px,1fr))", gap: 12, marginBottom: 24 }}>
              <StatCard icon={DollarSign} label="Ingresos" value={CLP(totalRevenue)} />
              <StatCard icon={Calendar} label="Reservas" value={reportBookings.length} />
              <StatCard icon={Check} label="Completadas" value={completedCount} />
            </div>

            <h3 className="jb-display" style={{ fontSize: 18, letterSpacing: 1, marginBottom: 12, color: "#e8e6da" }}>INGRESOS POR SERVICIO</h3>
            {byService.length === 0 ? (
              <p style={{ color: "#6f6d62", fontSize: 13 }}>Sin datos para este período.</p>
            ) : (
              <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
                {byService.map(([name, total]) => (
                  <div key={name} style={{ display: "flex", justifyContent: "space-between", background: "#1C1C18", border: "1px solid #2c2c26", borderRadius: 8, padding: "10px 14px" }}>
                    <span style={{ fontSize: 13.5 }}>{name}</span>
                    <span className="jb-mono" style={{ fontSize: 13.5, color: "#C9A227" }}>{CLP(total)}</span>
                  </div>
                ))}
              </div>
            )}
          </div>
        )}

        {tab === "share" && <SharePanel />}
        {tab === "settings" && <SettingsPanel />}
      </main>
      <footer style={{ borderTop: "1px solid #24241f", marginTop: 20 }}>
        <CreatorSeal />
      </footer>
    </div>
  );
}

function StatCard({ icon: Icon, label, value }) {
  return (
    <div style={{ background: "#1C1C18", border: "1px solid #2c2c26", borderRadius: 12, padding: 18 }}>
      <div style={{ display: "flex", alignItems: "center", gap: 8, color: "#8C8A7D", fontSize: 12.5, marginBottom: 8 }}>
        <Icon size={14} color="#C9A227" /> {label}
      </div>
      <div className="jb-mono" style={{ fontSize: 24, fontWeight: 600 }}>{value}</div>
    </div>
  );
}

function SettingsPanel() {
  const [current, setCurrent] = useState("");
  const [next, setNext] = useState("");
  const [confirm, setConfirm] = useState("");
  const [msg, setMsg] = useState("");
  const [err, setErr] = useState("");

  const changePassword = async () => {
    setErr(""); setMsg("");
    const cfg = await loadAdminConfig();
    if (current !== cfg.password) return setErr("La contraseña actual no coincide.");
    if (next.length < 4) return setErr("La nueva contraseña debe tener al menos 4 caracteres.");
    if (next !== confirm) return setErr("La confirmación no coincide.");
    await saveAdminConfig({ password: next, platformUrl: cfg.platformUrl });
    setMsg("Contraseña actualizada correctamente.");
    setCurrent(""); setNext(""); setConfirm("");
  };

  return (
    <div className="jb-fade" style={{ maxWidth: 380 }}>
      <h3 className="jb-display" style={{ fontSize: 18, letterSpacing: 1, marginBottom: 14, color: "#e8e6da" }}>CAMBIAR CONTRASEÑA</h3>
      <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
        <div>
          <label style={{ fontSize: 12, color: "#8C8A7D" }}>Contraseña actual</label>
          <input type="password" value={current} onChange={(e) => setCurrent(e.target.value)} className="jb-input" style={inputStyle} />
        </div>
        <div>
          <label style={{ fontSize: 12, color: "#8C8A7D" }}>Nueva contraseña</label>
          <input type="password" value={next} onChange={(e) => setNext(e.target.value)} className="jb-input" style={inputStyle} />
        </div>
        <div>
          <label style={{ fontSize: 12, color: "#8C8A7D" }}>Confirmar nueva contraseña</label>
          <input type="password" value={confirm} onChange={(e) => setConfirm(e.target.value)} className="jb-input" style={inputStyle} />
        </div>
        {err && <p style={{ color: "#f4b8b8", fontSize: 12.5 }}>{err}</p>}
        {msg && <p style={{ color: "#8fd39a", fontSize: 12.5 }}>{msg}</p>}
        <button onClick={changePassword} className="jb-btn" style={{ padding: "12px 0", borderRadius: 8, border: "none", background: "#C9A227", color: "#131311", fontWeight: 700, fontSize: 14, cursor: "pointer", marginTop: 6 }}>
          Guardar cambios
        </button>
      </div>
    </div>
  );
}

function SharePanel() {
  const [url, setUrl] = useState(DEFAULT_PLATFORM_URL);
  const [draft, setDraft] = useState(DEFAULT_PLATFORM_URL);
  const [copied, setCopied] = useState(false);
  const [saved, setSaved] = useState(false);

  useEffect(() => {
    (async () => {
      const cfg = await loadAdminConfig();
      const finalUrl = cfg.platformUrl || DEFAULT_PLATFORM_URL;
      setUrl(finalUrl);
      setDraft(finalUrl);
    })();
  }, []);

  const qrSrc = `https://api.qrserver.com/v1/create-qr-code/?size=280x280&margin=10&color=241-241-234&bgcolor=19-19-17&data=${encodeURIComponent(url)}`;
  const adminUrl = `${url.replace(/#.*$/, "").replace(/\/?$/, "/")}#admin`;
  const adminQrSrc = `https://api.qrserver.com/v1/create-qr-code/?size=280x280&margin=10&color=201-162-39&bgcolor=19-19-17&data=${encodeURIComponent(adminUrl)}`;

  const saveUrl = async () => {
    const cfg = await loadAdminConfig();
    await saveAdminConfig({ password: cfg.password, platformUrl: draft.trim() });
    setUrl(draft.trim());
    setSaved(true);
    setTimeout(() => setSaved(false), 2000);
  };

  const copyUrl = async () => {
    try {
      await navigator.clipboard.writeText(url);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch {
      /* clipboard no disponible, se ignora */
    }
  };

  return (
    <div className="jb-fade" style={{ maxWidth: 420 }}>
      <h3 className="jb-display" style={{ fontSize: 18, letterSpacing: 1, marginBottom: 6, color: "#e8e6da" }}>
        <Share2 size={16} style={{ verticalAlign: -2, marginRight: 6, color: "#C9A227" }} />
        CÓDIGO QR DE RESERVAS
      </h3>
      <p style={{ fontSize: 12.5, color: "#8C8A7D", marginBottom: 18 }}>
        Imprimí este QR y pegalo en el local. Los clientes lo escanean y llegan directo a reservar su hora.
      </p>

      <div style={{ background: "#1C1C18", border: "1px solid #2c2c26", borderRadius: 14, padding: 20, textAlign: "center" }}>
        <img src={qrSrc} alt="Código QR hacia la plataforma de reservas" width={220} height={220} style={{ borderRadius: 8, background: "#131311", padding: 10 }} />
        <p className="jb-mono" style={{ fontSize: 11.5, color: "#8C8A7D", marginTop: 12, wordBreak: "break-all" }}>{url}</p>
        <div style={{ display: "flex", gap: 8, marginTop: 14, justifyContent: "center" }}>
          <a href={qrSrc} download="jbarber-qr.png" className="jb-btn" style={{ ...smallBtnStyle, textDecoration: "none", display: "inline-flex", alignItems: "center", gap: 6 }}>
            <QrCode size={13} /> Descargar QR
          </a>
          <button onClick={copyUrl} className="jb-btn" style={{ ...smallBtnStyle, display: "inline-flex", alignItems: "center", gap: 6 }}>
            <Copy size={13} /> {copied ? "Copiado" : "Copiar link"}
          </button>
        </div>
      </div>

      <h4 style={{ fontSize: 13, color: "#8C8A7D", marginTop: 22, marginBottom: 8 }}>Link de la plataforma</h4>
      <p style={{ fontSize: 11.5, color: "#6f6d62", marginBottom: 8 }}>
        Esto debería ser la URL real de tu sitio en Netlify (ej: https://jbarber.netlify.app/). Actualizala acá y ambos QR se generan solos.
      </p>
      <div style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
        <input value={draft} onChange={(e) => setDraft(e.target.value)} className="jb-input" style={{ ...inputStyle, marginTop: 0, flex: 1, minWidth: 200 }} />
        <button onClick={saveUrl} className="jb-btn" style={{ ...smallBtnStyle, background: "#C9A227", color: "#131311", border: "none", fontWeight: 700, whiteSpace: "nowrap" }}>
          {saved ? "Guardado" : "Guardar"}
        </button>
      </div>

      <h3 className="jb-display" style={{ fontSize: 18, letterSpacing: 1, margin: "34px 0 6px", color: "#e8e6da" }}>
        <Lock size={15} style={{ verticalAlign: -2, marginRight: 6, color: "#C9A227" }} />
        QR DE ACCESO AL PANEL
      </h3>
      <p style={{ fontSize: 12.5, color: "#8C8A7D", marginBottom: 18 }}>
        Este QR abre directo la pantalla de login del panel — pegalo en un lugar fijo del local, solo visible para el barbero.
        Igual va a pedir la contraseña, así que es seguro aunque lo vea un cliente.
      </p>
      <div style={{ background: "#1C1C18", border: "1px solid #2c2c26", borderRadius: 14, padding: 20, textAlign: "center" }}>
        <img src={adminQrSrc} alt="Código QR de acceso al panel del barbero" width={220} height={220} style={{ borderRadius: 8, background: "#131311", padding: 10 }} />
        <p className="jb-mono" style={{ fontSize: 11.5, color: "#8C8A7D", marginTop: 12, wordBreak: "break-all" }}>{adminUrl}</p>
        <div style={{ display: "flex", gap: 8, marginTop: 14, justifyContent: "center" }}>
          <a href={adminQrSrc} download="jbarber-qr-panel.png" className="jb-btn" style={{ ...smallBtnStyle, textDecoration: "none", display: "inline-flex", alignItems: "center", gap: 6 }}>
            <QrCode size={13} /> Descargar QR
          </a>
        </div>
      </div>
    </div>
  );
}

const smallBtnStyle = { background: "#26241a", border: "1px solid #2c2c26", color: "#e8e6da", padding: "9px 14px", borderRadius: 8, cursor: "pointer", fontSize: 12.5 };
const navBtnStyle = { background: "#1C1C18", border: "1px solid #2c2c26", color: "#e8e6da", padding: "8px 10px", borderRadius: 8, cursor: "pointer" };
const iconBtnStyle = { background: "#26241a", border: "1px solid #2c2c26", color: "#e8e6da", padding: "7px", borderRadius: 6, cursor: "pointer", display: "flex" };

/* ============================================================
   ROOT APP
============================================================ */

export default function App() {
  const [route, setRoute] = useState(() =>
    typeof window !== "undefined" && window.location.hash === "#admin" ? "admin-login" : "client"
  );
  const [bookings, setBookings] = useState([]);
  const [loading, setLoading] = useState(true);

  const refreshBookings = useCallback(async () => {
    const list = await loadBookings();
    setBookings(list);
  }, []);

  useEffect(() => {
    (async () => {
      await refreshBookings();
      setLoading(false);
    })();
    // refresco periódico para que el panel y el sitio público se mantengan al día
    const interval = setInterval(refreshBookings, 20000);
    return () => clearInterval(interval);
  }, [refreshBookings]);

  if (loading) {
    return (
      <div style={{ minHeight: "100vh", background: "#131311", color: "#8C8A7D", display: "flex", alignItems: "center", justifyContent: "center", fontFamily: "'Inter',sans-serif" }}>
        Cargando...
      </div>
    );
  }

  if (route === "admin-login") {
    return <AdminLogin onSuccess={() => setRoute("admin-dashboard")} goClient={() => { window.location.hash = ""; setRoute("client"); }} />;
  }
  if (route === "admin-dashboard") {
    return <AdminDashboard bookings={bookings} refreshBookings={refreshBookings} onLogout={() => { window.location.hash = ""; setRoute("client"); }} />;
  }
  return <ClientView bookings={bookings} refreshBookings={refreshBookings} goAdmin={() => { window.location.hash = "admin"; setRoute("admin-login"); }} />;
}
