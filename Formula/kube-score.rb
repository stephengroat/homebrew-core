class KubeScore < Formula
  desc "Kubernetes object analysis recommendations for improved reliability and security"
  homepage "https://kube-score.com"
  url "https://github.com/zegl/kube-score/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "a09198f9a49c0008f9a34b418d85d3eb1299d0f04077e423eff30f1cad8abd43"
  license "MIT"
  head "https://github.com/zegl/kube-score.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/kube-score"
  end

  test do
    (testpath/"test.yaml").write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: node-port-service-with-ignore
        namespace: foospace
        annotations:
          kube-score/ignore: service-type
      spec:
        selector:
          app: my-app
        ports:
        - protocol: TCP
          port: 80
          targetPort: 8080
        type: NodePort
    EOS
    assert_match "The services selector does not match any pods", shell_output("#{bin}/kube-score score test.yaml", 1)
  end
end
