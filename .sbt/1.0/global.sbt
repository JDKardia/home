Global / onChangedBuildSource := ReloadOnSourceChanges

libraryDependencies += {
  val version = scalaBinaryVersion.value match {
    case "2.10" => "1.0.3"
    case "2.11" => "1.6.7"
    case _ ⇒ "2.5.2"
  }
  "com.lihaoyi" % "ammonite" % version % "test" cross CrossVersion.full
}

sourceGenerators in Test += Def.task {
  val file = (sourceManaged in Test).value / "amm.scala"
  IO.write(file, """object amm extends App { ammonite.AmmoniteMain.main(args) }""")
  Seq(file)
}.taskValue
