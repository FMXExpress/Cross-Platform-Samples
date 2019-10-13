object DataModule1: TDataModule1
  OldCreateOrder = False
  Height = 448
  Width = 258
  object FDTable1: TFDTable
    Connection = FDConnection1
    UpdateOptions.AutoIncFields = 'Id'
    Left = 168
    Top = 72
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 128
    Top = 16
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 120
    Top = 144
  end
  object FDSQLiteSecurity1: TFDSQLiteSecurity
    DriverLink = FDPhysSQLiteDriverLink1
    Left = 112
    Top = 208
  end
  object FDMemTable1: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftAutoInc
      end
      item
        Name = 'DateTime'
        DataType = ftDateTime
      end
      item
        Name = 'Title'
        DataType = ftWideString
        Size = 512
      end
      item
        Name = 'Link'
        DataType = ftWideString
        Size = 1024
      end
      item
        Name = 'Description'
        DataType = ftWideMemo
      end
      item
        Name = 'Author'
        DataType = ftWideString
        Size = 256
      end
      item
        Name = 'Guid'
        DataType = ftWideString
        Size = 512
      end
      item
        Name = 'Feed'
        DataType = ftWideString
        Size = 128
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    UpdateOptions.AutoIncFields = 'Id'
    StoreDefs = True
    Left = 64
    Top = 72
  end
end
