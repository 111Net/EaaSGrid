export default function AppShell({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="flex w-full">
      <aside className="w-64 bg-black border-r border-gray-800 p-4">
        EAASGrid
      </aside>

      <main className="flex-1 p-6">
        {children}
      </main>
    </div>
  );
}
