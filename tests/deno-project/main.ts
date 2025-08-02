import { serve } from "std/http/server.ts";

const handler = (req: Request): Response => {
  return new Response("Hello from Deno!");
};

serve(handler, { port: 8000 });