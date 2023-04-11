const path = Deno.args[0];

Deno.chdir(path);

const deleteGitWorktrees = async  (output:string)=>{
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
}

const deleteGitBranches = async  (output:string)=>{
  for (const branch of output.split("\n").map((line)=>line.trim())){
    if(branch){
      const deleteWorktree = Deno.run({
        cmd: ["git", "branch", "-D", branch],
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
}


const worktreeCmd = Deno.run({
  cmd: ["git", "worktree", "list"],
  stdout: "piped",
  stderr: "piped",
  });

const branchCmd = Deno.run({
  cmd: ["git", "branch", "-l", "kolacampbell*"],
  stdout: "piped",
  stderr: "piped",
  });

const worktreeCmdResult = await worktreeCmd.status();
if (worktreeCmdResult.code === 0) {
  const rawOutput = await worktreeCmd.output();
  const output = new TextDecoder().decode(rawOutput);
  await deleteGitWorktrees(output);
} else {
  const rawError = await worktreeCmd.stderrOutput();
  const errorString = new TextDecoder().decode(rawError);
  console.log(errorString);
}

const branchCmdResult = await branchCmd.status();
if (branchCmdResult.code === 0) {
  const rawOutput = await branchCmd.output();
  const output = new TextDecoder().decode(rawOutput);
  await deleteGitBranches(output);
} else {
  const rawError = await branchCmd.stderrOutput();
  const errorString = new TextDecoder().decode(rawError);
  console.log(errorString);
}
