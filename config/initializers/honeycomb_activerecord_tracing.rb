require 'active_record/connection_adapters/sqlite3_adapter'

# See https://www.justinweiss.com/articles/rails-5-module-number-prepend-and-the-end-of-alias-method-chain/
module ExecQueryWithSpan
  def exec_query(sql, name = nil, binds = [], prepare: false)
    with_span("exec_query", sql: sql, query_name: name) do
      super
    end
  end
end

ActiveRecord::ConnectionAdapters::SQLite3Adapter.send(:prepend, ExecQueryWithSpan)
