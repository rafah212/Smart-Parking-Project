import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

const TWILIO_ACCOUNT_SID = Deno.env.get("TWILIO_ACCOUNT_SID")!;
const TWILIO_AUTH_TOKEN = Deno.env.get("TWILIO_AUTH_TOKEN")!;
const TWILIO_VERIFY_SERVICE_SID = Deno.env.get("TWILIO_VERIFY_SERVICE_SID")!;

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

function toFormData(data: Record<string, string>) {
  const form = new URLSearchParams();
  for (const [key, value] of Object.entries(data)) {
    form.append(key, value);
  }
  return form;
}

async function twilioRequest(path: string, body: Record<string, string>) {
  const auth = btoa(`${TWILIO_ACCOUNT_SID}:${TWILIO_AUTH_TOKEN}`);

  const response = await fetch(
    `https://verify.twilio.com/v2/Services/${TWILIO_VERIFY_SERVICE_SID}/${path}`,
    {
      method: "POST",
      headers: {
        "Authorization": `Basic ${auth}`,
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: toFormData(body),
    }
  );

  const data = await response.json();

  return new Response(
    JSON.stringify({
      success: response.ok,
      data,
      error: data?.message,
    }),
    {
      status: response.ok ? 200 : 400,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    }
  );
}

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  const { action, phoneNumber, code } = await req.json();

  if (action === "send") {
    return await twilioRequest("Verifications", {
      To: phoneNumber,
      Channel: "sms",
    });
  }

  if (action === "check") {
    return await twilioRequest("VerificationCheck", {
      To: phoneNumber,
      Code: code,
    });
  }

  return new Response(JSON.stringify({ error: "Invalid action" }), {
    status: 400,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
});