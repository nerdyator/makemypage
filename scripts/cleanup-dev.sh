#!/bin/bash

# Cleanup script for Libra dev processes
# This kills all dev-related processes and frees up ports

echo "🧹 Cleaning up development processes..."

# Kill all bun dev processes
echo "Killing bun dev processes..."
pkill -f "bun.*dev" 2>/dev/null || true

# Kill all wrangler processes
echo "Killing wrangler processes..."
pkill -f "wrangler" 2>/dev/null || true

# Kill all workerd processes
echo "Killing workerd processes..."
pkill -f "workerd" 2>/dev/null || true

# Kill all esbuild processes
echo "Killing esbuild processes..."
pkill -f "esbuild.*--service" 2>/dev/null || true

# Kill Next.js dev servers
echo "Killing Next.js processes..."
pkill -f "next dev" 2>/dev/null || true

# Kill any processes on common dev ports
echo "Freeing up ports..."
for port in 3000 3001 3002 3003 3004 3007 3008 3009 5173 9229; do
  lsof -ti:$port 2>/dev/null | xargs kill -9 2>/dev/null || true
done

# Wait a moment for processes to die
sleep 2

# Verify ports are free
echo ""
echo "📊 Port status:"
for port in 3000 3001 3002 3003 3004 3007 3008 3009; do
  if lsof -i:$port >/dev/null 2>&1; then
    echo "  ❌ Port $port still in use"
  else
    echo "  ✅ Port $port is free"
  fi
done

echo ""
echo "✨ Cleanup complete!"
