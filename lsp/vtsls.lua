return {
  filetypes = { 'javascript', 'typescript', 'vue' },
  -- Pass --max-old-space-size directly to Node to prevent SIGABRT on large repos
  cmd_env = { NODE_OPTIONS = '--max-old-space-size=8192' },
  handlers = {
    -- Suppress the "TypeScript crashed N times, send report" dialog
    ['window/showMessageRequest'] = function(err, result, ctx, config)
      if result and result.message and result.message:lower():find 'crash' then
        return vim.NIL
      end
      return vim.lsp.handlers['window/showMessageRequest'](err, result, ctx, config)
    end,
  },
  settings = {
    vtsls = {
      tsserver = {
        maxTsServerMemory = 8192,
      },
    },
  },
  on_attach = function(client, bufnr)
    if vim.bo[bufnr].filetype == 'vue' then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
}
