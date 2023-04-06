const path = Deno.args[0];

Deno.chdir(path);

const p = Deno.run({
  cmd: ["git", "worktree", "list"],
  stdout: "piped",
  stderr: "piped",
  });

const { code } = await p.status();
if (code === 0) {
  const rawOutput = await p.output();
  const output = new TextDecoder().decode(rawOutput);

  for (const line of output.split("\n")){
    const worktree = line.split(" ")[0].slice(path.length+1);
    if(worktree){
      const deleteWorktree = Deno.run({
        cmd: ["git", "worktree", "remove", worktree],
        stdout: "piped",
        stderr: "piped",
      });
      const { code } = await deleteWorktree.status();
      if (code === 0) {
        const rawOutput = await deleteWorktree.output();
        const output = new TextDecoder().decode(rawOutput);
        console.log(output);
      } else {
        const rawError = await deleteWorktree.stderrOutput();
        const errorString = new TextDecoder().decode(rawError);
        console.log(errorString);
      }
    }
  }
} else {
  const rawError = await p.stderrOutput();
  const errorString = new TextDecoder().decode(rawError);
  console.log(errorString);
}
